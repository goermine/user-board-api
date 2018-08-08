class Account < ApplicationRecord
  belongs_to :user
  has_many :wallets
  has_many :account_transactions, through: :wallets, class_name: 'WalletTransaction'
  validates :user, uniqueness: true

  before_create :assign_account_number

  private

  def assign_account_number
    self.account_number = SecureRandom.random_number(rand(100000000))
  end
end
