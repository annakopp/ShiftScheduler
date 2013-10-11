class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :first_name, :last_name, :manager_id, :password_digest, :session_token, :user_type, :password, :account_status
  attr_reader :password

  validates :password_digest, :presence => { :message => "Password can't be blank" }
  validates :password, :length => { :minimum => 6, :allow_nil => true }
  #validates :session_token, :presence => true
  validates_uniqueness_of :email
  validates :email, :presence => true
  validates_presence_of :first_name, :last_name, :user_type, :account_status

  after_initialize :ensure_session_token


  has_many :companies,
  class_name: "Company",
  primary_key: :id,
  foreign_key: :admin_id

  has_many :employees,
  class_name: "User",
  primary_key: :id,
  foreign_key: :manager_id

  has_many :created_shifts,
  class_name: "Shift",
  primary_key: :id,
  foreign_key: :manager_id

  has_many :shift_requests,
  class_name: "ShiftRequest",
  primary_key: :id,
  foreign_key: :employee_id

  has_many :working_shifts, through: :shift_requests, source: :shift

  belongs_to :manager,
  class_name: "User",
  primary_key: :id,
  foreign_key: :manager_id

  belongs_to :company,
  class_name: "Company",
  primary_key: :id,
  foreign_key: :company_id

  def admin?
    self.user_type == "admin"
  end


  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)

    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end

  def reset_password
    new_pwd = SecureRandom::urlsafe_base64(7)
    self.password = new_pwd
    self.save
  end

  def can_request?(shift)
    return false if shift.slots >= shift.max_slots
    return false if overlap?(shift)
    !self.shift_requests.find_by_employee_id_and_shift_id(self.id, shift.id)
  end


  def can_cancel?(shift)
    request = self.shift_requests.find_by_employee_id_and_shift_id(self.id, shift.id)
    request && request.status == "pending"

  end

  def overlap?(shift)
    working_shifts.each do |working_shift|
      return true if shift.end_date >= working_shift.start_date && working_shift.end_date >= shift.start_date
    end
    false
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end




end
