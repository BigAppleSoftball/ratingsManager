require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'Cannot Create Profile Without an email address' do
    profile = valid_user
    profile.email = nil
    assert_not profile.save
  end

  test 'Cannot Create Profile With Duplicate Email Address' do
    ap profiles(:one).email
    profile = valid_user
    profile.email = profiles(:one).email
    assert_not profile.save
  end


  #
  # Creates a User that is Valid to Save
  #
  def valid_user
    profile = Profile.new
    profile.first_name = "test"
    profile.last_name = "test"
    profile.password = "123456"
    profile.password_confirmation = "123456"
    profile.email = "gdfgdfgdfg@gmail.com"
    profile
  end
end
