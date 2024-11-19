class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  has_many :requests
  has_many :histories
  has_many :messages
  has_many :books, through: :histories

end
