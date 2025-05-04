class AddBannerToClub < ActiveRecord::Migration[7.2]
  def change
    add_column :clubs, :banner, :string
  end
end
