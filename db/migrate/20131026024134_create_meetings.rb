class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :location
      t.datetime :beginning_at
      t.datetime :ending_at
      t.timestamps
    end
  end
end
