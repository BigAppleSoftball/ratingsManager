module ErrorsHelper

  def inactive_season
     redirect_to root_path, notice: 'You cannot edit an inactive season.'
  end
end