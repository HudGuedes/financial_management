class CreateCostCenters < ActiveRecord::Migration[6.1]
  def change
    create_table :cost_centers do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.text :description

      t.timestamps
    end

    add_index :cost_centers, :code, unique: true
  end
end
