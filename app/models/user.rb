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

  belongs_to :manager,
  class_name: "User",
  primary_key: :id,
  foreign_key: :manager_id

  belongs_to :company,
  class_name: "Company",
  primary_key: :id,
  foreign_key: :company_id

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

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
