class CreateWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_transactions do |t|
      t.integer :sender_id, index: true, null: false
      t.integer :beneficiary_id, index: true, null: false
      t.integer :wallet_from, index: true
      t.integer :wallet_to, index: true, null: false
      t.foreign_key :wallets, column: :wallet_from, primary_key: :wallet_number, on_delete: :cascade
      t.foreign_key :wallets, column: :wallet_to, primary_key: :wallet_number, on_delete: :cascade

      t.integer :sum, null: false
      t.string :transaction_id, null: false, unique: true
      t.string :method, null: false
      t.string :type, null: false
      t.timestamps
    end
  end
end
