module ErrorsHelper

  def inactive_season
     redirect_to :back, notice: 'You cannot edit an inactive season.'
  end
end