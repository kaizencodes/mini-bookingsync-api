class Booking < ApplicationRecord
  validates :client_email, presence: true, email: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :start_at, presence: true, datetime: { after: proc { Date.today } }
  validates :end_at, presence: true, datetime: { after: :start_at }

  belongs_to :rental

  before_validation do
    set_price
    BookingPolicy.new(self).enforce
  end

  def start_date
    return unless start_at
    start_at.to_date
  end

  def end_date
    return unless end_at
    end_at.to_date
  end

  def self.calculate_price(from, to, id)
    missing_params = from.nil? || to.nil? || id.nil?
    return if missing_params

    rental = Rental.find(id)
    (to.to_date - from.to_date).to_i * rental.daily_rate
  end

  private

  def set_price
    return if start_at.nil? || end_at.nil? || rental.nil?
    self.price = Booking.calculate_price(start_at, end_at, rental_id)
  end
end
