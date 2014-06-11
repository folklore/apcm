class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :email,    uniq: true
      t.boolean :is_admin, default: false
      t.integer :city_id,  null: false

      t.timestamps
    end

    add_index :users, :city_id

  end
end