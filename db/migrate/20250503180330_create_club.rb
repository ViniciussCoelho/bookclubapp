class CreateClub < ActiveRecord::Migration[7.2]
  def change
    create_table :clubs do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.jsonb :chat_messages, default: []

      t.timestamps
    end
  end
end
