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

  test "multiple arguments" do
    assert @user.address
    assert @user.picture
  end

  test "has_many association" do
    assert @user.projects.first
  end

  test "has_many with :count" do
    assert_equal 3, @user.nicknames.length
  end

  test "has_many with existing values" do
    @user.save
    assert_equal 1, User.last.projects.size
  end

  test "has_many with :count and :append raises error"  do
    assert_raise AutoBuild::AutoBuildError do
      @user.class_eval do
        auto_build :nicknames, :count => 3, :append => true
      end
    end
  end

  test "has_one doesn't save the association, only builds it" do
    assert !@user.address.persisted?
  end

  test "belongs_to association" do
    @order = Order.new
    assert @order.user
  end
end
