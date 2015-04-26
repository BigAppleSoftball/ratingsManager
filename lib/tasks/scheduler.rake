desc "This task is called by the Heroku scheduler add-on"

require "#{Rails.root}/app/helpers/payments_tracker_helper"
require "#{Rails.root}/app/helpers/teamsnap_helper"
include PaymentsTrackerHelper
include TeamsnapHelper

#rake run_payment_sync 
task :run_payment_sync => :environment do
  puts "Updating payments..."
  sync_payment_data
  puts "Payments Synced."
end

#rake send_division_emails
task :run_payment_send_division_emails => :environment do
  puts "Updating payments..."
  sync_payment_data
  puts "Payments Synced."

  account = TeamsnapScanAccount.order('created_at DESC').first
  loginHash = log_in_to_teamsnap(account.username,account.password, false)
  if (loginHash[:teamsnapToken])
    divisions = teamsnap_divs_by_id
    divisions.each do |key, value|
      if value == 16139
        break
      end
      puts "Sending Roster Email For: #{key}"
      send_web_team_roster_email(value,key,loginHash[:teamsnapToken])
    end
  else
    puts "ERROR: Teamsnap Login Failed, no emails sent"
  end

end