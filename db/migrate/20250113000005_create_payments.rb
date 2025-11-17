class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :charge, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :payment_date, null: false
      t.text :notes

      t.timestamps
    end

    add_index :payments, :payment_date
  end
end
