class Account < ApplicationRecord
  belongs_to :user
  has_many :wallets
  has_many :account_transactions, through: :wallets, class_name: 'WalletTransaction'
  validates :account_number, presence: true 
  validates :user, uniqueness: true

  before_validation(on: :create) do 
     assign_account_number
  end

  private

  def assign_account_number
    self.account_number = SecureRandom.random_number(rand(100000000))
  end
end
