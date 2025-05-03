class CreateClubUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :club_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :club, null: false, foreign_key: true
      t.boolean :is_admin, default: false

      t.timestamps
    end
    
    add_index :club_users, [:user_id, :club_id], unique: true
  end
end 