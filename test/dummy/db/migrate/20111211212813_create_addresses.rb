class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.belongs_to :user

      t.timestamps
    end
  end
end
