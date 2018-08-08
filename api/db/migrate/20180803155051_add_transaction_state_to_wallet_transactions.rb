class AddTransactionStateToWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :wallet_transactions, :transaction_state, :string
  end
end
