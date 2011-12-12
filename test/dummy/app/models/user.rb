class User < ActiveRecord::Base
  has_one :address
  has_one :phone
  has_one :picture

  auto_build :address, :picture
end
