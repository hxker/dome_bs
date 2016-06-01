class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :school_type, null: false
      t.integer :district_id, null: false
      t.boolean :status, null: false, default: 1
      t.boolean :audit
      t.boolean :user_add, null: false, default: false
      t.integer :user_id
      t.timestamps
    end
    add_index :schools, :name
    add_index :schools, :school_type
    add_index :schools, [:district_id, :school_type, :name], unique: true, name: 'index_schools'
    add_index :schools, :district_id
    add_index :schools, [:school_type, :district_id]
    add_index :schools, :user_add
    add_index :schools, [:user_id, :user_add, :status], name: 'index_user_add_schools'
    add_index :schools, :status
    add_index :schools, :audit
  end
end
