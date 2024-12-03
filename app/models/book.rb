class Book < ApplicationRecord
  has_one_attached :photo

  has_many :requests
  has_many :histories, dependent: :destroy
  has_many :users, through: :histories
  geocoded_by :location

  def current_owner
    self.histories.last.user
  end

  include PgSearch::Model
  pg_search_scope :search_by_title_and_description,
  against: [ :title, :description, :authors ],
  using: {
    tsearch: { prefix: true }
  }
end
