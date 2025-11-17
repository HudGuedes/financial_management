class CreateGuardians < ActiveRecord::Migration[6.1]
  def change
    create_table :guardians do |t|
      t.string :name, null: false
      t.string :cpf
      t.string :email
      t.string :phone

      t.timestamps
    end

    add_index :guardians, :cpf, unique: true
    add_index :guardians, :email
  end
end
