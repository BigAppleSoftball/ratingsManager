require 'rails'

module TestUtils
  extend self

  def rails_version
    @rails_version ||= Gem::Version.new(Rails.version)
  end

  def rails_version_in_range?(minimum_version, maximum_version)
    minimum_version = Gem::Version.new(minimum_version) if minimum_version.is_a?(String)
    maximum_version = Gem::Version.new(maximum_version) if maximum_version.is_a?(String)
    minimum_version <= rails_version && rails_version < maximum_version
  end

  def dummy_app_dir
    major_version = if rails_3?
      '3'
    elsif rails_4?
      '4'
    else
      raise "Unsupported Rails version #{TestUtils.rails_version}"
    end
    "dummy-rails#{major_version}"
  end

  def reset_fixture_cache
    fixture_set.reset_cache
  end

  def create_fixtures(*args)
    fixture_set.create_fixtures(*args)
  end

  private

  def fixture_set
    rails_3? ? ActiveRecord::Fixtures : ActiveRecord::FixtureSet
  end

  def rails_3?
    rails_version_in_range?('3.2.0', '4.0.0')
  end

  def rails_4?
    rails_version_in_range?('4.0.0', '5.0.0')
  end
end

