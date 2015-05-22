# In config/initializers/rack-attack.rb
class Rack::Attack
   ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 1000, :period => 5.minutes) do |req|
    req.ip # unless req.path.starts_with?('/assets')
  end


  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  throttle('signins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/signin' && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /login by email param
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{req.email}"
  #
  # Note: This creates a problem where a malicious user could intentionally
  # throttle logins for another user and force their login requests to be
  # denied, but that's not very common and shouldn't happen to you. (Knock
  # on wood!)
  throttle("signin/email", :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/signin' && req.post?
      # return the email if present, nil otherwise
      req.params['email'].presence
    end
  end

  # Block requests from 180.76.15.34
  # This is a china user we've been seeing a bunch of requests from
  # obviously malicious
  blacklist('block 180.76.*') do |req|
    # Requests are blocked if the return value is truthy
    '180.76.*' == req.ip
  end

end