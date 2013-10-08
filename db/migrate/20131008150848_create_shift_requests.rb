class CreateShiftRequests < ActiveRecord::Migration
  def change
    create_table :shift_requests do |t|
      t.integer :shift_id
      t.integer :employee_id
      t.string :status

      t.timestamps
    end
  end
end
