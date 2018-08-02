class Wallet < ApplicationRecord
  belongs_to :account
  has_many :wallet_transactions
  validates :wallet_number, presence: true
  validates :currency, inclusion: { in: %w[USD EUR GBR] }, if: :currency
  validate :validate_uniq_currency_for_account

  before_validation :assign_wallet_number

  private

  def assign_wallet_number
    self.wallet_number = SecureRandom.hex(30)
  end

  def validate_uniq_currency_for_account
    return unless Wallet.where(account_id: account_id, currency: currency).any?
    errors.add(:account_id, 'Wallet with specified currency already is present')
  end
end
