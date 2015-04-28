module ApplicationHelper
  def unranked_class(ranking)
    if ranking.nil?
      "unranked-player danger"
    end
  end

  def get_current_ranking(player)
    ranking = nil
    customData = player['league_custom_data']
    customData.each do |customItem|
      if customItem["custom_field_id"] == 81158
        ranking = customItem["content"]
      end
    end
    ranking
  end

  def set_current_ranking(currentRanking)
    if currentRanking.nil?
      'N/A'
    else
      currentRanking
    end
  end

  def get_team_sponsors(teamId)
    teams_sponsors = TeamsSponsor.where(:team_id => teamId)
    teamSponsors = Array.new
    teams_sponsors.each do |team_sponsor|
      teamSponsors.push(team_sponsor)
    end
    teamSponsors
  end

  def get_team_rosters(teamId)
    teams_roster = Roster.where(:team_id => teamId)
    teamRosters = Array.new
    teams_roster.each do |roster|
      teamRosters.push(roster)
    end
    teamRosters
  end

  def yes_or_no_icon(bool)
    if (bool)
      "<i class='glyphicon glyphicon-ok yes-icon'></i>"
    else
      "<i class='glyphicon glyphicon-remove no-icon'></i>"
    end
  end

  def get_park_statuses
    field_statuses = {0 => 'All Open', 1 => 'Some Closed', 2 => 'All Closed'}
    field_statuses
  end

  def sortable(column, title = nil, isAlphabet = false, isNum = false)
    title ||= column.titleize
    
    css_class = column == sort_column ? "current-column #{sort_direction}" : 'sortable-column'
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'

    if column == sort_column
      if sort_direction == 'asc'
        
        if isAlphabet 
          icon = "fa fa-sort-alpha-asc"
        elsif isNum
          icon = "fa fa-sort-numeric-asc"
        else
          icon = 'fa fa-sort-amount-asc'
        end
      else 
        if isAlphabet 
          icon = "fa fa-sort-alpha-desc"
        elsif isNum
          icon = "fa fa-sort-numeric-desc"
        else
          icon = 'fa fa-sort-amount-desc'
        end
      end
    else
      icon = 'fa fa-sort'
    end

    link_to raw("#{title} <i class='#{icon}'></i>"), params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  #
  # Gets the list of fields by park
  #
  #  park_name: [{field}]
  def fields_by_park
    all_fields = Field.order('park_id ASC').all
    fields_by_park = Hash.new
    current_park_id = 0
    all_fields.each do |field|
      if (current_park_id == field.park_id)
        if fields_by_park[field.park.name].empty?
          fields_by_park[field.park.name] = Array.new
        end
        fields_by_park[field.park.name].push(field)
      else # new park
        current_park_id = field.park_id
        fields_by_park[field.park.name] = Array.new
        fields_by_park[field.park.name].push(field)
      end
    end
    fields_by_park
  end

  #
  # Sets the attendance class for a player row
  #
  def attendance_class(attendance)
    ap '------------------------'
    is_attending_class = nil
    ap 'attendance'
    ap attendance.nil?
    if !attendance.nil?
      is_attending = attendance.is_attending
      if is_attending
        is_attending_class = 'is-attending'
      else
        is_attending_class = 'is-not-attending'
      end
    end
    is_attending_class
  end
end
