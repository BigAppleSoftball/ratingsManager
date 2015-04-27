require File.expand_path('../test_utils', __FILE__)

require 'coveralls'
Coveralls.wear!

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path("../#{TestUtils.dummy_app_dir}/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'mocha/setup'

puts "Rails #{Rails.version} is loaded"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('../fixtures', __FILE__)
end

class ActionController::TestCase
  include Devise::TestHelpers

  protected

  def set_up_devise
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
end

