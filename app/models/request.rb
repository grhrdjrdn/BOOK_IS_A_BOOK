class Request < ApplicationRecord
  has_many :messages
  belongs_to :user
  belongs_to :book
  belongs_to :history
  enum :status, { pending: 0, swapped: 1, denied: 2 }
end
