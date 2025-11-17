class CreatePaymentPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_plans do |t|
      t.references :guardian, null: false, foreign_key: true
      t.references :cost_center, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :payment_plans, [:guardian_id, :cost_center_id]
  end
end
