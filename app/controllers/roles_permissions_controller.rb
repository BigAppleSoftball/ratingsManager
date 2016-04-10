class RolesPermissionsController < ApplicationController
  before_action :set_roles_permission, only: [:show, :edit, :update, :destroy]
  before_filter {|c| c.has_permissions_redirect get_permissions[:CanEditAllRoles]}

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

  #
  # Endpoint from Roles for removing a permission
  #
  def remove_permission_from_role
    permissionId = params[:permission_id]
    roleId = params[:role_id]
    # find the roles_permission based on the Params
    rp = RolesPermission.where(:role_id => roleId, :permission_id => permissionId).first
    rp.destroy
    response = Hash.new
    response[:success] = rp.destroyed?
    response[:role_id] = roleId
    response[:permission_id] = permissionId
    respond_to do |format|
      format.json {
        render json: response
      }
    end
  end

  def add_permission_to_role
    permissionId = params[:permission_id]
    roleId = params[:role_id]
    rps = RolesPermission.where(:role_id => roleId, :permission_id => permissionId)
    message = nil
    if (!rps.empty?)
      success = false
      message = "This Role Already Exists"
    else
      # find the roles_permission based on the Params
      success = true
      role_permission = RolesPermission.new
      role_permission[:permission_id] = permissionId
      role_permission[:role_id] = roleId
      view = render_to_string "roles/_role_permission_item.haml", :layout => false, :locals => { :role => role_permission.role, :permission => role_permission.permission}
      role_permission.save
    end
    response = Hash.new
    response[:success] = success
    response[:html] = view
    response[:message] = message
    respond_to do |format|
      format.json {
        render json: response
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roles_permission
      @roles_permission = RolesPermission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roles_permission_params
      params.require(:roles_permission).permit(:role_id, :permission_id)
    end
end
