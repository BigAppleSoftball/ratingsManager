class StaticPagesController < ApplicationController

  def home
    @sponsors = Sponsor.where(:show_carousel => true)
    @parkStatus = get_all_park_statues
  end

  def contact
    
  end
end
