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

end
