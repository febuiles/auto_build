class User < ActiveRecord::Base
  has_one :address
  has_one :phone
  has_one :picture
  has_many :projects

  auto_build :address, :picture
  auto_build :projects#, :times => 3
end
