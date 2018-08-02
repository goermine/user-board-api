class Wallet < ApplicationRecord
  belongs_to :account
  has_many :wallet_transactions
  validates :wallet_number, presence: true
  validates :currency, inclusion: { in: %w[USD EUR GBR] }, if: :currency

  before_validation :assign_wallet_number

  private

  def assign_wallet_number
    self.wallet_number = SecureRandom.random_number(rand(100000000))
  end
end
