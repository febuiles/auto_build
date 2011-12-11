require 'test_helper'

class AutoBuildTest < ActiveSupport::TestCase
  setup do
    @user = User.new
    @address = Address.new(:street => "Highway 61")
  end

  test "an association with auto_build" do
    assert @user.address
  end

  test "an association without auto_build" do
    assert !@user.phone
  end

  test "does not ovewrite existing values" do
    @address.save
    user = User.create!(:address => @address)

    found_user = User.last
    assert_equal found_user.address, @address
  end
end
