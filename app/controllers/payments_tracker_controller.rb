class PaymentsTrackerController < ApplicationController
  require 'open-uri'
  include TeamsnapHelper
  include PaymentsTrackerHelper

  def index
  end

  #
  # Renders view that shows all buttons to go to individual divisions
  #
  def divisions
    @divisions = teamsnap_divs_by_id
  end

  #
  # Renders the view that shows the entire team roster and valid players for a given division
  #
  def division
    division_id = params[:divisionId].to_i
    # we know the division Id but I also want to grab the name
    division = teamsnap_divs_by_id.select{|key, value| value == division_id }
    @division_name = division.first.first
    @division_id = division_id
    @div_data = get_division_team_data(@division_id)
    # get the rosters of all teams in this division

  end

  #
  # Triggers sending the email to the given Rep
  #
  def emailDivisionRep
    division_id = params[:divisionId].to_i
    division = teamsnap_divs_by_id.select{|key, value| value == division_id }
    send_division_rep_roster_email(params[:divisionId].to_i,division.first.first, nil)
    render 'email_confirmation'
  end


  def emailWebteam
    division_id = params[:divisionId].to_i
    division = teamsnap_divs_by_id.select{|key, value| value == division_id }
    send_web_team_roster_email(division_id, division.first.first, nil)
    render 'email_confirmation'
  end

  def new_account
    @teamsnap_sync_account = TeamsnapScanAccount.new
    render 'payments_tracker/account/new'
  end

  def send_all_emails
    run_payments_scan_send_emails(true)
  end

  def create_account
    @account = TeamsnapScanAccount.new(teamsnap_scan_account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to '/payments/tracker', notice: 'Scans Account was successfully created.' }
      else
        format.html { redirect_to 'payments_tracker#new_account', notice: 'Error Saving Account.' }
      end
    end

  end

  # home page for the page tracker
  def home
    mechanize = Mechanize.new
    @players = log_in_get_player_info(mechanize)
  end

  def admin
    @scans = TeamsnapPaymentsSync.order('created_at DESC').all
    @latest_sync = TeamsnapPaymentsSync.order('created_at DESC').first
  end

  #
  # Gets a list of paid players on unassigned teams
  #
  def unassigned
    mechanize = Mechanize.new
    players = log_in_get_player_info(mechanize)
    ids_by_div_name = teamsnap_divs_by_id
    @unassigned_player = Array.new
    @league_id = ids_by_div_name["Big Apple Softball League"]
    players_by_payments = sort_players(players)
    players_by_payments[:paid].each do |player|
      if player['division_id'] == @league_id
        @unassigned_player.push(player)
      end
    end
  end

  def sync
    sync_payment_data
  end

  def add_new_payment
    @payment = TeamsnapPayment.new
  end

  def list
    @payments = TeamsnapPayment.all
  end


  private

  private
    def teamsnap_scan_account_params
      params.require(:teamsnap_scan_account).permit(:username, :password, :is_active)
    end

end