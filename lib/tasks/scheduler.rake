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

#rake run_payment_send_division_emails
task :run_payment_send_division_emails => :environment do
  run_payments_scan_send_emails
end