class Shift < ActiveRecord::Base
  attr_accessible :end_date, :manager_id, :name, :slots, :start_date, :max_slots

  validates_presence_of :end_date, :manager_id, :name, :max_slots, :start_date

  #validates_uniqueness_of :name, scope: [:manager_id]

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
    self.slots = self.shift_requests.count
    self.save
  end

  def as_json(options={})

    json = { start: DateTime.parse(start_date.to_s).iso8601,
             end: DateTime.parse(end_date.to_s).iso8601,
             title: name,
             slots: slots,
             id: id,
             allDay: false,
             backgroundColor: self.max_slots > self.slots  ? "green" : "red"
           }
    json
  end



end
