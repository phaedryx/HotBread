class TweakUser < ActiveRecord::Migration
  def up
    remove_column :users, :username
    remove_column :users, :member
    rename_column :users, :phone_number, :phone
  end

  def down
    add_column :users, :username, :string
    add_column :users, :member, :boolean
    rename_column :users, :phone, :phone_number
  end
end
