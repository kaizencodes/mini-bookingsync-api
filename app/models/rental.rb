class Rental < ApplicationRecord
  validates :name, presence: true
  validates :daily_rate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :bookings
end
