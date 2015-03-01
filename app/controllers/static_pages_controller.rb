class StaticPagesController < ApplicationController

  def home
    @sponsors = Sponsor.where(:show_carousel => true)
    @fieldStatus = get_all_field_statues
  end
end
