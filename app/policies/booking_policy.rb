class BookingPolicy
  def initialize(booking)
    @booking = booking
  end

  def enforce
    no_overlap
    minimum_booking_time
  end

  private

  def no_overlap
    other_bookings_at_rental = Booking.where(rental: @booking.rental).where.not(id: @booking.id)

    bookings_end_before = other_bookings_at_rental.where("end_at < ? ", @booking.start_date)
    bookings_start_after = other_bookings_at_rental.where("start_at > ? ", @booking.end_date)

    overlap = other_bookings_at_rental.count > bookings_end_before.count + bookings_start_after.count
    if overlap
      @booking.errors.add(:base, "Overlapping with other booking")
      return false
    end
    true
  end

  def minimum_booking_time
    # this could go into rental as an attribute if we want custom minimum times
    minimum_booking_time = 1
    return false unless @booking.start_date && @booking.end_date
    if @booking.end_date - @booking.start_date < minimum_booking_time
      @booking.errors.add(:base, "Booking time cannot be less than #{minimum_booking_time} day(s)")
      return false
    end
    true
  end
end
