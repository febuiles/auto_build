class User < ActiveRecord::Base
  has_one :address
  has_one :phone

  auto_build :address
end
