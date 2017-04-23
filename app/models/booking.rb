class Booking < ApplicationRecord
  MINIMUM_BOOKING_TIME = 1.day

  validates :client_email, presence: true, email: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :start_at, presence: true, datetime: { before: :end_at, after: proc { DateTime.now } }
  validates :end_at, presence: true, datetime: { after: :start_at }

  belongs_to :rental

  before_validation do
    calculate_price
    BookingPolicy.new(self).enforce
  end

  def start_date
    return unless start_at
    start_at.to_date
  end

  # because to_date discards the time portion, we add that day.
  # so we get an inclusive range from start to end
  def end_date
    return unless start_at
    (end_at + 1.day).to_date
  end

  private

  def calculate_price
    return if start_at.nil? || end_at.nil?
    self.price = (end_date - start_date).to_i * rental.daily_rate
  end
end
