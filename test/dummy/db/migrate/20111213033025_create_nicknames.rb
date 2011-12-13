class CreateNicknames < ActiveRecord::Migration
  def change
    create_table :nicknames do |t|
      t.string :nick
      t.integer :user_id

      t.timestamps
    end
  end
end
