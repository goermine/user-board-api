class CreateWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_transactions do |t|
      t.string :transaction_id, null: false, unique: true
      t.integer :sender_id, index: true, null: false
      t.integer :beneficiary_id, index: true, null: false
      t.integer :wallet_from, index: true
      t.integer :wallet_to, index: true
      t.integer :sum, null: false
      t.string :charge_method, null: false
      t.string :type, null: false


      t.foreign_key :wallets, column: :wallet_from, on_delete: :cascade
      t.foreign_key :wallets, column: :wallet_to, on_delete: :cascade
      t.foreign_key :users, column: :sender_id
      t.foreign_key :users, column: :beneficiary_id

      t.timestamps
    end
  end
end
