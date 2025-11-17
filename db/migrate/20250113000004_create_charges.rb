class CreateCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :charges do |t|
      t.references :payment_plan, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :due_date, null: false
      t.integer :payment_method, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :payment_code

      t.timestamps
    end

    add_index :charges, :status
    add_index :charges, :due_date
    add_index :charges, :payment_code, unique: true
  end
end
