class AddMaxSlotsToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :max_slots, :integer
    change_column :shifts, :slots, :integer, default: 0
  end
end
