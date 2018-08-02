class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.references :account
      t.string :wallet_number, null: false, unique: true
      t.string :currency, null: false, default: "USD"
      t.integer :amount, default: 0
      t.timestamps
    end
    add_index :wallets, [:account_id, :currency], unique: true
    add_index :wallets, [:account_id, :wallet_number], unique: true
    add_foreign_key :wallets, :accounts, on_delete: :cascade
  end
end
