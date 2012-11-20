class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :address
      t.references :user

      t.timestamps
    end
    add_index :orders, :address_id
    add_index :orders, :user_id
  end
end
