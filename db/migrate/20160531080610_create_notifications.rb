class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.text :content
      t.integer :message_type, null: false, default: 0
      t.integer :team_id
      t.integer :t_u_id
      t.integer :reply_to
      t.boolean :read, default: false

      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :read
    add_index :notifications, :message_type
    add_index :notifications, :t_u_id
    add_index :notifications, :team_id
  end
end
