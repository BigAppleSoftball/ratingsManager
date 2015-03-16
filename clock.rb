require 'clockwork'
require 'open-uri'

module Clockwork
  job_url = 'https://basl-manager.herokuapp.com/payments/sync.json'

  handler do |job|
    puts "Running #{job}, at #{time}" 
  end

  every(6.hours, 'Data Sync for Payments') {
    open(job_url)
  }
end