class ImportsController < ApplicationController
   before_filter {|c| c.has_permissions_redirect get_permissions[:CanImport]}

  def index
    @seasons = Season.all
  end

  def upload
    $team_added_count = 0
    $divisions_added_count = 0
    $profiles_added_count = 0
    $roster_update_count = 0
    selected_season_id = params[:seasons].to_i
    file = params[:file]['csv']
    # load the details for the selected season
    selected_season = Season.eager_load(:divisions => :teams).find(selected_season_id)

    if !(file.nil?)
      season = Hash.new
      seasonDivisions = Hash.new
      # process csv
      CSV.foreach(file.path, headers: true) do |row|

        rTeam = get_and_clean(row, 'Team')
        rDivision = get_and_clean(row, 'Division')
        rFirstName = get_and_clean(row, 'First Name')
        rLastName = get_and_clean(row, 'Last Name')
        rEmail = get_and_clean(row, 'Email Address')
        rAddress = get_and_clean(row, 'Address')
        rCity    = get_and_clean(row, 'City')
        rState   = get_and_clean(row, 'State')
        rZip     = get_and_clean(row, 'Zip')
        rGender  = get_and_clean(row, 'Gender')
        rAffliation = get_and_clean(row, 'Team Affliation')
        rNonPlayer = get_and_clean(row, 'Player / Non-Player')
        rPickup  = row['Are you available as a pick-up player during the season?']

        # if that division doesn't exist create it and add Team
        if (seasonDivisions[rDivision].nil?)
          seasonDivisions[rDivision] = Hash.new
        end
        # if that team doesn't exist in the Division Create it
        
        if (seasonDivisions[rDivision][rTeam].nil?)
          seasonDivisions[rDivision][rTeam] = Array.new
        end

        player = createNewPlayer(rFirstName, rLastName, rEmail, rPickup, rAddress, rCity, rState, rZip, rGender,rAffliation, rNonPlayer)

        seasonDivisions[rDivision][rTeam].append(player)
        
      end
    else 
    end
    divisions = selected_season.divisions

    # save the divisions to the given season
    seasonDivisions.each do |name, dTeams|
      # Check if Division is in season
      division = check_or_create_division(name, divisions, selected_season_id)

      dTeams.each do |name, players|
        team = check_or_create_team(name, division.id)
        players.each do |player|
          profile = check_or_create_profile(player[:first_name], player[:last_name], player[:email], player[:is_pickup_player], player[:address], player[:city], player[:state], player[:zip], player[:gender])
          check_or_add_roster(profile.id, team.id, profile[:is_team_manager], profile[:is_non_player])
        end

      end
    end
    @selected_season = selected_season
  end

  private
    def check_or_add_roster(profile_id, team_id, is_manager, is_non_player)
      roster = Roster.where(:profile_id => profile_id, :team_id => team_id).first
      if roster.nil?
        return add_roster(profile_id, team_id, is_manager, is_non_player)
      else
        return roster
      end
    end

    #
    # Adding profile to a team via roster
    #
    def add_roster(profile_id, team_id, is_manager, is_non_player)
      $roster_update_count += 1
      roster = Roster.new
      if (is_manager)
        roster[:is_manager] = true
      end

      if (is_non_player)
        roster[:is_non_player] = true
      end
      roster[:profile_id] = profile_id
      roster[:team_id] = team_id
      roster[:is_active] = true
      roster.save
      roster
    end

    def check_or_create_profile(fName, lName, email, pickup, address, city, state, zip, gender)
      profile = Profile.where(:email => email).first
      if (profile.nil?)
        profile = Profile.new
        return create_profile(profile,fName, lName, email, pickup, address, city, state, zip, gender)
      else
        return update_profile(profile, fName, lName, email, pickup,  address, city, state, zip, gender)
      end
    end


    def update_profile(profile, fName, lName, email, pickup,  address, city, state, zip, gender)
      profile[:email] = email
      profile[:first_name] = fName
      profile[:last_name] = lName
      profile[:is_pickup_player] = pickup
      profile[:address] = address
      profile[:city] = city
      profile[:state] = state
      profile[:zip] = zip
      profile[:gender] = gender
      profile.save(validate: false)
      profile
    end

    #
    # checks whether a team with the given name and
    # division_id exists, if not it creates it
    # @returns team
    #
    def check_or_create_team(name, division_id)
      selected_team = Team.where(:name => name, :division_id => division_id).first

      if (selected_team.nil?)
        return create_team(name, division_id)
      else
        return selected_team
      end
    end

    def create_team(name, division_id) 
      $team_added_count += 1
      team = Team.new
      team[:name] = name
      team[:division_id] = division_id
      team.save
      team
    end

    #
    # Checks if a division exists if not it creates it
    #
    def check_or_create_division(name, divisions, selected_season_id)
      selected_season_division = Division.where(:description => name, :season_id => selected_season_id).first

      if selected_season_division.nil?
        # create a new division
        return create_division(name, selected_season_id)
      else
        return selected_season_division
      end
    end

    #
    # Create a new division
    #
    def create_division(name, season_id)
      $divisions_added_count += 1
      division = Division.new
      division[:description] = name
      division[:season_id] = season_id
      division.save
      division
    end

    #
    # Gets String from a row and strips the White Space
    #
    def get_and_clean(row, label)
      result = row[label]
      if result.nil?
        return result
      else
        return result.strip
      end
    end

    #
    # Creates a New Player Object and returns it
    #
    def createNewPlayer(fname, lname, email, pickup, address, city, state, zip, gender, affliation, nonPlayer)
      player = Hash.new
      player[:first_name] = fname
      player[:last_name] = lname
      player[:email] = email
      player[:address] = address
      player[:city] = city
      player[:state] = state
      player[:zip] = zip
      player[:gender] = gender
      if (pickup.present? && pickup.include?('Yes'))
        player[:is_pickup_player] = true
      end
      if (affliation.present? && affliation.include?('Manager'))
        player[:is_team_manager] = true
      end
      if (nonPlayer.present? && nonPlayer.include?('Non-Player'))
        player[:is_non_player] = true
      end

      player
    end
end