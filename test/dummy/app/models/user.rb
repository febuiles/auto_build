class User < ActiveRecord::Base
  has_one :address
  has_one :phone
  has_one :picture

  has_many :projects
  has_many :nicknames

  auto_build :address, :picture
  auto_build :projects
  auto_build :nicknames, :count => 3
end
