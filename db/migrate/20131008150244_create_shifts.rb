class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer :manager_id
      t.string :name
      t.integer :slots
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
