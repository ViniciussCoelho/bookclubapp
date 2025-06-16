class CreateReadings < ActiveRecord::Migration[7.2]
  def change
    create_table :readings do |t|
      t.references :club, null: false, foreign_key: true
      t.string :title
      t.string :author
      t.integer :total_pages
      t.date :start_date
      t.date :end_date
      t.boolean :current_reading
      t.text :description

      t.timestamps
    end
  end
end
