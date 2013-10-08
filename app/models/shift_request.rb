class ShiftRequest < ActiveRecord::Base
  attr_accessible :employee_id, :shift_id, :status

  belongs_to :employee,
  class_name: "Employee",
  primary_key: :id,
  foreign_key: :employee_id

  belongs_to :shift,
  class_name: "Shift",
  primary_key: :id,
  foreign_key: :shift_id

  validates_uniqueness_of :employee_id, scope: [:shift_id]
end
