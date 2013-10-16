class Shift < ActiveRecord::Base
  attr_accessible :end_date, :manager_id, :name, :slots, :start_date, :max_slots
  attr_accessor :requested, :can_request, :can_cancel

  validates_presence_of :end_date, :manager_id, :name, :max_slots, :start_date

  validate :start_date_after_end_date, on: :create

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


  def count_slots
    self.slots = self.shift_requests.where(status: "approved").count
    self.save
  end

  def as_json(options={})

    json = { start: DateTime.parse(start_date.to_s).iso8601,
             end: DateTime.parse(end_date.to_s).iso8601,
             title: name,
             slots: slots,
             id: id,
             allDay: false,
             className: requested,
             max_slots: max_slots,
             can_request: can_request,
             can_cancel: can_cancel,
             shift_requests: shift_requests,
             employees: employees
           }
    json
  end

  def requested?(user)
    return false if user.admin?
    !!self.employees.include?(user)
  end


  def request_status(user)
    return "full" unless available?
    return "available" if user.admin?
    req = self.shift_requests.select{|req| req.employee_id == user.id}.first  
   
    req ? req.status : "available"
  end

  def can_be_requested_by?(user)
    return false if user.admin? || manager_id != user.manager_id || overlap?(user) 
    request_status(user) == "available"  
  end


  def can_be_cancelled_by?(user)
    return false if user.admin? || manager_id != user.manager_id
    request_status(user) == "pending"
  end

  def overlap?(user)
    user.working_shifts.each do |working_shift|
      return true if end_date >= working_shift.start_date && working_shift.end_date >= start_date
    end
    false
  end

  private
  
  def available?
    max_slots > slots
  end

  def start_date_after_end_date
    if self.start_date > self.end_date
      errors.add(:start_date, "start date can't be after end date")
    end
  end


end
