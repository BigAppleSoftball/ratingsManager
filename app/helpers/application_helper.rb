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


end
