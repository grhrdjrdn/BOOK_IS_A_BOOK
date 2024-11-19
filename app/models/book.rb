class Book < ApplicationRecord
  has_one_attached :photo

  has_many :requests
  has_many :histories, dependent: :destroy
  has_many :users, through: :histories

  def current_owner
    self.histories.last.user
  end
end
