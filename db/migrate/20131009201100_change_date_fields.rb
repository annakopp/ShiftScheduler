class ChangeDateFields < ActiveRecord::Migration
  def change
    remove_column :shifts, :start_time
    remove_column :shifts, :end_time
    change_table :shifts do |t|
      t.remove :start_date
      t.remove :end_date
      t.datetime :start_date
      t.datetime :end_date
    end
  end
end
