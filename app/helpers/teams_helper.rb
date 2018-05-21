module TeamsHelper
  def is_team_rep(team)
    return is_team_manager?(team.id) || is_division_rep?(team.division.id)
  end
end
