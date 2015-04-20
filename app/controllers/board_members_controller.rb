class BoardMembersController < ApplicationController
  before_action :set_board_member, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:edit, :update, :destroy]

  # GET /board_members
  # GET /board_members.json
  def index
    @board_members = BoardMember.order('display_order ASC').all
  end

  # GET /board_members/1
  # GET /board_members/1.json
  def show
  end

  # GET /board_members/new
  def new
    @board_member = BoardMember.order('display_order ASC').new
    @profiles = Profile.all
  end

  # GET /board_members/1/edit
  def edit
    @profiles = Profile.all
  end

  # POST /board_members
  # POST /board_members.json
  def create
    @board_member = BoardMember.new(board_member_params)

    respond_to do |format|
      if @board_member.save
        format.html { redirect_to @board_member, notice: 'Board member was successfully created.' }
        format.json { render :show, status: :created, location: @board_member }
      else
        format.html { render :new }
        format.json { render json: @board_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /board_members/1
  # PATCH/PUT /board_members/1.json
  def update
    respond_to do |format|
      if @board_member.update(board_member_params)
        format.html { redirect_to @board_member, notice: 'Board member was successfully updated.' }
        format.json { render :show, status: :ok, location: @board_member }
      else
        format.html { render :edit }
        format.json { render json: @board_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /board_members/1
  # DELETE /board_members/1.json
  def destroy
    @board_member.destroy
    respond_to do |format|
      format.html { redirect_to board_members_url, notice: 'Board member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def all_board
    @boardMembers = BoardMember.order('display_order ASC').where(:is_committee_lead => false)
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board_member
      @board_member = BoardMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_member_params
      params.require(:board_member).permit(:email, :position, :display_order, :first_name, :last_name, :alt_email, :image_url, :is_committee_lead, :profile_id, :teamsnap_id, :teamsnap_name)
    end
end
