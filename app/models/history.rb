class History < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :requests

  def next_history
    History.where(book_id: book_id)
           .where("date_acquired > ?", date_acquired)
           .order(date_acquired: :asc)
           .first
  end


end
