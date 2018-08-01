class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.references :account, index: true, null: false
      t.foreign_key :accounts, column: :account_id, primary_key: :account_number, on_delete: :cascade
      t.string :wallet_number, null: false, unique: true
      t.string :currency, null: false, default: "USD"
      t.integer :amount, default: 0
      t.timestamps
    end
  end
end
