class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :location
  validate :location_must_be_geocodable
  after_validation :geocode, if: :will_save_change_to_location?

  private

  # Custom validation method
  def location_must_be_geocodable
    result = Geocoder.search(location).first
    if result.nil?
      errors.add(:location, "Could not be geocoded. Please enter a valid address.")
    end
  end

  has_many :requests
  has_many :histories
  has_many :messages
  has_many :books, through: :histories
end
