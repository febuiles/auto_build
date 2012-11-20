class Order < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

	auto_build :address
	auto_build :user
end
