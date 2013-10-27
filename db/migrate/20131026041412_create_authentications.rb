class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :uid
      t.string  :provider
      t.integer :user_id
      t.timestamps
    end
  end
end
