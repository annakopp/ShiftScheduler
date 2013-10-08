class ChangeShiftTimeFields < ActiveRecord::Migration
  def change
    remove_column :shifts, :start_date
    remove_column :shifts, :end_date

    add_column :shifts, :start_date, :date
    add_column :shifts, :end_date, :date

    add_column :shifts, :start_time, :time
    add_column :shifts, :end_time, :time

  end
end
