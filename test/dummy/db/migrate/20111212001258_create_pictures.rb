class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :path
      t.belongs_to :user

      t.timestamps
    end
  end
end
