class Book < ApplicationRecord
  has_one_attached :photo

  has_many :requests
  has_many :histories
  has_many :users, through: :histories

end
