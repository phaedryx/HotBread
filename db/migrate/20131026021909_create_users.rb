class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username
      t.string   :name
      t.string   :email
      t.string   :phone_number
      t.boolean  :member
      t.timestamps
    end
  end
end
