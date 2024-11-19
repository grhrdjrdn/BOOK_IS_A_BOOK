class Book < ApplicationRecord
  has_one_attached :photo
  has_many :histories, dependent: :destroy
  has_many :users, through: :histories
end
