class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.string  :title,  limit: 140
      t.text    :content
      t.string  :status

      t.timestamps
    end

    add_index :notes, :user_id
  end
end