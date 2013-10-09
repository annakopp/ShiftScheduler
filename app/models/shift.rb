class Shift < ActiveRecord::Base
  attr_accessible :end_date, :manager_id, :name, :slots, :start_date, :end_time, :start_time

  validates_presence_of :end_date, :manager_id, :name, :slots, :start_date, :end_time, :start_time

  validates_uniqueness_of :name, scope: [:manager_id]

  belongs_to :manager,
  class_name: "Manager",
  primary_key: :id,
  foreign_key: :manager_id

  has_many :shift_requests,
  class_name: "ShiftRequest",
  primary_key: :id,
  foreign_key: :shift_id,
  dependent: :destroy

  has_many :employees, through: :shift_requests, source: :employee

  def decrement_slots
    self.slots >=0 ? self.slots -= 1 : self.slots = 0
    self.save
  end

  def as_json(options={})

    json = { end: end_date.to_s + "T"+ end_time.strftime("%H:%M") + ":00Z",
             start: start_date.to_s + "T"+ start_time.strftime("%H:%M") + ":00Z",
             title: name,
             slots: slots,
             allDay: false
           }
    json
  end

end
