class User < ApplicationRecord
  has_one :user_profile, :dependent => :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :notifications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :timeoutable, :authentication_keys => [:login]

  validates :nickname, presence: true, uniqueness: true, length: {in: 2..10}, format: {with: /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/i, message: '昵称只能包含中文、数字、字母、下划线'}
  validates :password, length: {in: 2..30}, format: {with: /\A[\x21-\x7e]+\Z/i, message: '密码只能包含数字、字母、特殊字符'}, allow_nil: true
  validates :password, presence: true, on: :create


  def email_changed?
    false
  end

  def email_required?
    false
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  attr_accessor :login
  attr_accessor :email_info
  attr_accessor :email_code
  attr_accessor :mobile_info
  attr_accessor :return_url

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['nickname = :value OR email = :value OR mobile = :value', {:value => login}]).first
    else
      where(conditions).first
    end
  end

  private

end
