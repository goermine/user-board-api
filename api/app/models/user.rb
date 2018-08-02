class User < ApplicationRecord
  has_secure_password

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
  /x

  has_one :account
  has_many :wallets, through: :account

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, :full_name, presence: true
  validates :password, presence: true,
                       length: { in: 8..20 }, password: true, on: :create
  validates :password, allow_nil: true,
                       length: { in: 8..20 }, password: true, on: :update
  validates :password_confirmation, presence: true

  def full_name
    [first_name, last_name].compact.join(' ').strip
  end

  def full_name=(name)
    split = name.split(' ', 2)
    self.first_name = split.first
    self.last_name = split.last
  end
end
