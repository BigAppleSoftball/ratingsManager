class RolesPermissionsController < ApplicationController
  before_action :set_roles_permission, only: [:show, :edit, :update, :destroy]

  # GET /roles_permissions
  # GET /roles_permissions.json
  def index
    @roles_permissions = RolesPermission.all
  end

  # GET /roles_permissions/1
  # GET /roles_permissions/1.json
  def show
  end

  # GET /roles_permissions/new
  def new
    @roles_permission = RolesPermission.new
  end

  # GET /roles_permissions/1/edit
  def edit
  end

  # POST /roles_permissions
  # POST /roles_permissions.json
  def create
    @roles_permission = RolesPermission.new(roles_permission_params)

    respond_to do |format|
      if @roles_permission.save
        format.html { redirect_to @roles_permission, notice: 'Roles permission was successfully created.' }
        format.json { render :show, status: :created, location: @roles_permission }
      else
        format.html { render :new }
        format.json { render json: @roles_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles_permissions/1
  # PATCH/PUT /roles_permissions/1.json
  def update
    respond_to do |format|
      if @roles_permission.update(roles_permission_params)
        format.html { redirect_to @roles_permission, notice: 'Roles permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @roles_permission }
      else
        format.html { render :edit }
        format.json { render json: @roles_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles_permissions/1
  # DELETE /roles_permissions/1.json
  def destroy
    @roles_permission.destroy
    respond_to do |format|
      format.html { redirect_to roles_permissions_url, notice: 'Roles permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roles_permission
      @roles_permission = RolesPermission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roles_permission_params
      params.require(:roles_permission).permit(:role_id, :permissions_id)
    end
end
