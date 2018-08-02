class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, index: true, unique: true
      t.string :account_number, null: false, unique: true
      t.foreign_key :users, column: :user_id, on_delete: :cascade
      t.timestamps
    end
  end
end
