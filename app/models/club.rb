class Club < ApplicationRecord
  has_many :users, through: :club_users
  has_many :club_users

  belongs_to :owner, class_name: "User"
end
