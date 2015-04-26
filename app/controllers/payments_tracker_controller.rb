class PaymentsTrackerController < ApplicationController
  require 'open-uri'
  include TeamsnapHelper
  include PaymentsTrackerHelper

  def index
  end

  def send_roster
    division_ids = teamsnap_divs_by_id
    target_div_name = '5. Sachs Division'
    targeted_division_id = teamsnap_divs_by_id[target_div_name]
    mechanize = Mechanize.new
    # get all teams
    @div_data = get_division_team_data(targeted_division_id)
    @div_name = target_div_name

    # Mail the roster payments
    PaymentMailer.payments_roster(@div_data, @div_name).deliver
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
    division_rep = BoardMember.where(:teamsnap_id => params[:divisionId].to_i).first
    repEmail = division_rep[:email]
    ccEmail = 'webteam@bigapplesoftball.com'

    sendDivisionRosterEmail(params[:divisionId].to_i, repEmail, ccEmail)
  end

    #
  # Triggers sending the email to the Webteam
  #
  def emailWebteam
    repEmail = 'webteam@bigapplesoftball.com'
    sendDivisionRosterEmail(params[:divisionId].to_i, repEmail, nil)
  end

  def sendDivisionRosterEmail(division_id, toEmail, ccEmail)

    # we know the division Id but I also want to grab the name
    division = teamsnap_divs_by_id.select{|key, value| value == division_id }
    @division_name = division.first.first

    @toEmail = toEmail
    @ccEmail = ccEmail
    @div_data = get_division_team_data(division_id)
    # get the rosters of all teams in this division
    PaymentMailer.payments_roster(@div_data, @division_name, toEmail, ccEmail).deliver
    render 'email_confirmation'
  end

  def teams_by_division
  end

  def new_account
    @teamsnap_sync_account = TeamsnapScanAccount.new
    render 'payments_tracker/account/new'
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