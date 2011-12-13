require 'test_helper'

class AutoBuildTest < ActiveSupport::TestCase
  setup do
    @user = User.new
    @address = Address.new(:street => "Highway 61")
    @project = Project.new(:title => "Reincarnation of Benjamin")
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

  test "multiple arguments" do
    assert @user.address
    assert @user.picture
  end

  test "has_many association" do
    assert @user.projects.first
  end

  test "has_many :times" do
#    assert_equal 3, @user.projects.length
  end

  test "has_many with existing values" do
    @project.save
    user = User.new
    user.projects.destroy_all
    user.projects << @project
    user.save

    found_user = User.last
    assert_equal 1, user.projects.size
  end
end
