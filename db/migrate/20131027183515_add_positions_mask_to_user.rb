class AddPositionsMaskToUser < ActiveRecord::Migration
  def change
    add_column :users, :positions_mask, :integer
  end
end
