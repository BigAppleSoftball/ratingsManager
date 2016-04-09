class ProfileRolesController < ApplicationController
  before_action :set_profile_role, only: [:show, :edit, :update, :destroy]

  # GET /profile_roles
  # GET /profile_roles.json
  def index
    @profile_roles = ProfileRole.all
  end

  # GET /profile_roles/1
  # GET /profile_roles/1.json
  def show
  end

  # GET /profile_roles/new
  def new
    @profile_role = ProfileRole.new
  end

  # GET /profile_roles/1/edit
  def edit
  end

  # POST /profile_roles
  # POST /profile_roles.json
  def create
    @profile_role = ProfileRole.new(profile_role_params)

    respond_to do |format|
      if @profile_role.save
        format.html { redirect_to @profile_role, notice: 'Profile role was successfully created.' }
        format.json { render :show, status: :created, location: @profile_role }
      else
        format.html { render :new }
        format.json { render json: @profile_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_roles/1
  # PATCH/PUT /profile_roles/1.json
  def update
    respond_to do |format|
      if @profile_role.update(profile_role_params)
        format.html { redirect_to @profile_role, notice: 'Profile role was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile_role }
      else
        format.html { render :edit }
        format.json { render json: @profile_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_roles/1
  # DELETE /profile_roles/1.json
  def destroy
    @profile_role.destroy
    respond_to do |format|
      format.html { redirect_to profile_roles_url, notice: 'Profile role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_role
      @profile_role = ProfileRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_role_params
      params.require(:profile_role).permit(:profle_id, :role_id)
    end
end
