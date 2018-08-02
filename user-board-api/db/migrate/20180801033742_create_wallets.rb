class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.references :account, index: true, uniqe: true
      t.string :wallet_number, null: false, unique: true
      t.foreign_key :wallets, column: :account_id, on_delete: :cascade
      t.string :currency, null: false, default: "USD"
      t.integer :amount, default: 0
      t.timestamps
    end
  end
end
