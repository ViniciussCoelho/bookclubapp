class CreateClub < ActiveRecord::Migration[7.2]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :descripion
      t.jsonb :chat_messages

      t.timestamps
    end
  end
end
