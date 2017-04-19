class Rental < ApplicationRecord
  validates :name, presence: true
  validates :daily_rate, presence: true
end
