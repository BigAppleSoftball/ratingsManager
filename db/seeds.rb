# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# read team CSV file and populate database

#rails generate scaffold Divisions div_id:integer season_id:integer pool_id:integer div_description:string div_order:integer standings:string team_cap:integer waitlist_cap:integer is_active:boolean
def generate_division_backup
  csvRows = get_csv_file('divisions.csv')
  csvRows.each do |row|
    division = Division.new(
      :id => row[:divid],
      :season_id => row[:seasonid],
      :pool_id => row[:poolid],
      :div_description => row[:divdesc],
      :div_order => row[:divorder],
      :standings => row[:standingstype],
      :team_cap => row[:teamcap],
      :waitlist_cap => row[:waitlistcap],
      :is_active => row[:isactive]
      )
    division.save
  end
end
#SeasonID LeagueID  SeasonDesc  DateStart DateEnd DateRegOpen DateRegClosed DateCreated DateUpdated
#rails generate scaffold Seasons season_id:integer league_id:integer pool_id:integer season_desc:string  date_start :datetime date_end:datetime
def generate_season_backup
  csvRows = get_csv_file('seasons.csv')
  csvRows.each do |row|
    season = Season.new(
      :id => row[:seasonid],
      :league_id => row[:leagueid],
      :pool_id => row[:poolid],
      :season_desc=> row[:seasondesc],
      :date_start => row[:datestart],
      :date_end => row[:dateend]
      )
    season.save
  end
end
# rails generate scaffold Sponsors sponsor_id:integer name:string url:string email:string phone:string details:string date_created:datetime date_updated:date_time created_user_id:integer updated_user_id:integer is_active:boolean                                                                                                                                       SponsorID  SponsorType SponsorName SponsorURL  SponsorEmail  SponsorPhone  SponsorDetails  DateCreated DateUpdated ByCreated ByUpdated IsActive
def generate_sponsors_backup
  csvRows = get_csv_file('sponsors.csv')
  csvRows.each do |row|
    sponsor = Sponsor.new(
      :id => row[:sponsorid],
      :name => row[:sponsorname],
      :url => row[:sponsorurl],
      :email => row[:sponsoremail],
      :phone => row[:sponsorphone],
      :details => row[ :sponsordetails],
      :date_created => row[:datecreated],
      :date_updated => row[:dateupdated],
      :created_user_id => row[:bycreated],
      :updated_user_id => row[:byupdated],
      :is_active => row[:isactive],
      :is_league => row[:isleague],
      :show_carousel => row[:showcarousel],
      :logo_url => row[:logourl]

      )
    sponsor.save
  end
end

#rails generate scaffold TeamsSponsors team_id:integer sponsor_id:integer is_active:boolean link_id:integer
def generate_team_sponsors_backup
  csvRows = get_csv_file('teamsponsors.csv')
  csvRows.each do |row|
    teamsponsor = TeamsSponsor.new(
      :team_id => row[:teamid],
      :sponsor_id => row[:sponsorid],
      :is_active => row[:isactive],
      :link_id => row[:linkid]
      )
    teamsponsor.save
  end
end
#ProfileID ParentOrgID ProfileCode FirstName LastName  Email Nickname  DisplayName Twitter Facebook  GooglePlus  PlayerNumber  Gender  Height  Weight  SizeTShirt  SizeJersey  SizeJacket  SizePants RelStatus Address City  State Zip Phone SMSNumber SMSDomain UrgentName  UrgentRelation  UrgentPhone UrgentEmail PrefLeague  PrefDiv PrefPositions PrefEmail ConfirmCode DateDOB DateCreated DateUpdated DateSignedIn  LeagueInterest  LeagueServed  TourneyInterest TourneyServed CommitteeInterest ByUpdated IsEmail IsPublic  IsFeatured  isRoleWeb isRoleBoard IsRoleLeagues IsRoleTourneys  IsRoleOps IsRolePay IsRoleRosters IsRoleRatings isConfirmed isActive  Password  PasswordHash  PasswordSalt  TeamID

#rails generate scaffold Profiles profile_code:string first_name:string last_name:string email:string nickname:string display_name:string player_number:integer gender:string shirt_size:string address:string state:string zip:integer phone:string emergency_name:string emergency_relation:string emergency_phone:string emergency_email:string position:string dob:string team_id:integer
def generate_profile_backup
  csvRows = get_csv_file('profiles.csv')
  csvRows.each do |row|
    profile = Profile.new(
      :id => row[:profileid],
      :profile_code => row[:profilecode],
      :first_name => row[:firstname],
      :last_name => row[:lastname],
      :email => row[:email],
      :nickname => row[:nickname],
      :display_name => row[:displayname],
      :player_number => row[:playernumber],
      :gender => row[:gender],
      :shirt_size => row[:shirtsize],
      :address => row[:address],
      :state => row[:state],
      :zip => row[:zip],
      :phone => row[:phone],
      :emergency_name => row[:emergencyname],
      :emergency_relation => row[:emergencyrelation],
      :emergency_phone => row[:emergencyphone],
      :emergency_email => row[:emergencyemail],
      :position => row[:prefosositions],
      :dob => row[:datedob],
      :team_id => row[:teamid]
    )
    profile.save
  end
end
#rails generate scaffold Teams division_id:integer long_name:string stat_loss:integer stat_win:integer stat_play:integer stat_pt_allowed:integer stat_pt_scored:integer stat_tie:integer teamsnap_id:integer team_desc:text name:string

def generate_team_backup
  csvRows = get_csv_file('teams.csv')
  csvRows.each do |row|
    team = Team.new(
    :id => row[:teamid],
    :division_id => row[:divid],
    :long_name => row[:longname],
    :stat_loss => row[:statlosses],
    :stat_win => row[:statwins],
    :stat_play => row[:statplayed],
    :stat_pt_allowed => row[:statptsallowed],
    :stat_pt_scored => row[:statptsscored],
    :stat_tie => row[:statties],
    :team_desc => row[:teamdesc],
    :name => row[:teamname],
    :team_code => row[:teamcode],
    :team_status => row[:teamcode],
    :win_perc => row[:statwinsperc],
    :stat_games_back => row[:statgamesback],
    :date_created => row[:datecreated],
    :date_updated => row[:dateupdated],
    :contact => row[:teamcontact],
    :email => row[:teamemail],
    :created_user_id => row[:bycreated],
    :updated_user_id => row[:byupdated]
    )
    team.save
  end
end

#RosterID TeamID  ProfileID DateCreated DateApproved  DateUpdated ByCreated ByUpdated ByApproved  IsApproved  IsPlayer  IsRep IsManager IsActive  IsConfirmed
# rails generate scaffold Rosters team_id:integer profile_id:integer date_created:datetime date_approved:datetime date_updated:date_updated is_approved:boolean is_player:boolean is_rep:boolean is_manager:boolean is_active:boolean is_confirmed:boolean
def generate_roster_backup
  csvRows = get_csv_file('rosters.csv')
  csvRows.each do |row|
    roster = Roster.new(
    :id => row[:rosterid],
    :team_id => row[:teamid],
    :profile_id => row[:profileid],
    :date_created => row[:datecreated],
    :date_approved => row[:dateapproved],
    :date_updated => row[:dateupdated],
    :is_approved => row[:isapproved],
    :is_player => row[:isplayer],
    :is_rep => row[:isrep],
    :is_manager => row[:ismanager],
    :is_active => row[:isactive],
    :is_confirmed => row[:isconfirmed]
    )
    roster.save
  end
end
#RatingID  ProfileID RatingNotes ApproverNotes RatingList  RatingTotal RatingDiv DateRated DateApproved  ByRated ByApproved  IsProvisional IsApproved  IsActive  History Updated Rating1 Rating2 Rating3 Rating4 Rating5 Rating6 Rating7 Rating8 Rating9 Rating10  Rating11  Rating12  Rating13  Rating14  Rating15  Rating16  Rating17  Rating18  Rating19  Rating20  Rating21  Rating22  Rating23  Rating24  Rating25  Rating26  Rating27  SSMA_TimeStamp  NG  NR
#rails generate scaffold Ratings profile_id:integer rating_notes:text approver_notes:text rating_list:string rating_total:integer date_rated:datetime date_approved:datetime rated_by_profile_id:integer approved_by_profile_id:integer is_provisional:boolean is_approved:boolean is_active:boolean history:text updated:text rating_1:integer rating_2:integer rating_3:integer rating_4:integer rating_5:integer rating_6:integer rating_7:integer rating_8:integer rating_9:integer rating_10:integer rating_11:integer rating_12:integer rating_13:integer rating_14:integer rating_15:integer rating_16:integer rating_17:integer rating_18:integer rating_19:integer rating_20:integer rating_21:integer rating_22:integer rating_23:integer rating_24:integer rating_25:integer rating_26:integer rating_27:integer ssma_timestamp:datetime ng:integer nr:integer
def generate_ratings_backup
  csvRows = get_csv_file('ratings.csv')

  csvRows.each do |row|
    row[:rating_list]
    rating = Rating.new(
    :id => row[:ratingid],
    :profile_id => row[:profileid],
    :rating_notes => row[:ratingnotes],
    :approver_notes => row[:approvernotes],
    :rating_list => row[:ratinglist],
    :rating_total => row[:ratingtotal],
    :date_rated => row[:daterated],
    :date_approved => row[:dateapproved],
    :is_approved => row[:isapproved],
    :rated_by_profile_id => row[:byrated],
    :approved_by_profile_id => row[:byapproved],
    :is_active => row[:isactive],
    :is_provisional => row[:isprovisional],
    :is_approved => row[:isapproved],
    :history => row[:history],
    :updated => row[:updated],
    :ssma_timestamp => row[:ssma_timeStamp],
    :ng => row[:ng],
    :nr => row[:nr]
    )
    generate_ratings_from_list(row, rating)
    rating.save
  end
end

#NomID ProfileID Bio DateNominated DateInducted  ByNominated IsInducted  IsActive

#rails generate HallofFamers profile_id:integer date_inducted:datetime is_active:boolean is_inducted:boolean
def generate_HOF_backup
  csvRows = get_csv_file('hof.csv')

  csvRows.each do |row|
    hallOfFamers = HallofFamer.new(
    :id => row[:nomid],
    :profile_id => row[:profileid],
    :date_inducted => row[:dateinducted],
    :is_active => row[:isactive],
    :is_inducted => row[:isinducted]
    )
    hallOfFamers.save
  end
end

def generate_admin_backup
  admin = Admin.new(
    :email => 'paigepon@gmail.com'
  )
  admin.save
end

def generate_name_for_hof
  hofs = HallofFamer.all
  hofs.each do |hof|
    hof[:first_name] = hof.profile.first_name
    hof[:last_name] = hof.profile.last_name
    hof.save
  end
end

def generate_board_members_backup
  csvRows = get_csv_file('board.csv')

  csvRows.each do |row|
    board_member = BoardMember.new(
    :first_name => row[:firstname],
    :last_name => row[:lastname],
    :is_division_rep => row[:div_rep],
    :email => row[:email],
    :position => row[:position],
    :display_order => row[:displayorder],
    :alt_email => row[:altemail]
    )
    board_member.save
  end
end

def set_display_order_hof
  hofs = HallofFamer.order('date_inducted ASC').all
  order = 0
  hofs.each do |hof|
    hof[:display_order] = order
    hof.save
    order+=1
  end
end
#LocID LocName LocAddress  LocCity LocState  LocZip  LocPhone  LocFax  LocTollFree LocMapURL LocByCar  LocByBus  LocByTrain  LocParking  LocDocURL DateUpdated ByUpdated IsVisible IsActive
def generate_fields_backup
  csvRows = get_csv_file('fields2.csv')

  csvRows.each do |row|
    field = Field.new(
    :is_active => row[:isactive],
    :address => row[:locaddress],
    :city => row[:loccity],
    :zip => row[:loczip],
    :by_car => row[:locbycar],
    :state=> row[:locstate],
    :by_bus => row[:locbybus],
    :by_train => row[:locbytrain],
    :parking => row[:locparking],
    :name => row[:locname],
    :google_map_url => row[:locmapurl],
    :status => 0
    )
    field.save
  end
end

def set_board_members_committee
  boards = BoardMember.all
  boards.each do |board|
    board[:is_committee_lead] = false
    board.save
  end
end


def generate_ratings_from_list(row, rating)
  ratingsList = row[:ratinglist].split(',')
  rating[:rating_1] = ratingsList[0]
  rating[:rating_2] = ratingsList[1]
  rating[:rating_3] = ratingsList[2]
  rating[:rating_4] = ratingsList[3]
  rating[:rating_5] = ratingsList[4]
  rating[:rating_6] = ratingsList[5]
  rating[:rating_7] = ratingsList[6]
  rating[:rating_8] = ratingsList[7]
  rating[:rating_9] = ratingsList[8]
  rating[:rating_10] = ratingsList[9]
  rating[:rating_11] = ratingsList[10]
  rating[:rating_12] = ratingsList[11]
  rating[:rating_13] = ratingsList[12]
  rating[:rating_14] = ratingsList[13]
  rating[:rating_15] = ratingsList[14]
  rating[:rating_16] = ratingsList[15]
  rating[:rating_17] = ratingsList[16]
  rating[:rating_18] = ratingsList[17]
  rating[:rating_19] = ratingsList[18]
  rating[:rating_20] = ratingsList[19]
  rating[:rating_21] = ratingsList[20]
  rating[:rating_22] = ratingsList[21]
  rating[:rating_23] = ratingsList[22]
  rating[:rating_24] = ratingsList[23]
  rating[:rating_25] = ratingsList[24]
  rating[:rating_26] = ratingsList[25]
  rating[:rating_27] = ratingsList[26]
end

def get_csv_file(fileName)
  file = File.join(Rails.root,'db', 'seeds', fileName)
  data = File.read(file)
  csv =  CSV.new(data, :headers => true,:header_converters => :symbol)
  csvRows = csv.to_a.map
  csvRows
end

def set_board_members_profile_id
  boards = BoardMember.all
  boards.each do |board|
    profile = Profile.where(:first_name => board.first_name, :last_name => board.last_name)
    if profile.length == 1
      board[:profile_id] = profile.first[:id]
    end
    board.save
  end
end

def move_long_image_url_to_profile
  boards = BoardMember.all
  boards.each do |board|
    if !board.profile.nil? && board[:image_url]
      board.profile[:long_image_url] = board[:image_url]
      board.profile.save
    end
  end
end

#generate_team_backup
#generate_division_backup
#generate_season_backup
#generate_sponsors_backup
#generate_team_sponsors_backup
#generate_profile_backup
#generate_roster_backup
#generate_ratings_backup
#generate_HOF_backup
#generate_admin_backup
#generate_name_for_hof
#generate_board_members_backup
#set_display_order_hof
#set_board_members_committee
#set_board_members_profile_id
#move_long_image_url_to_profile
#generate_fields_backup