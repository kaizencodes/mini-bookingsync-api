require "rails_helper"

RSpec.describe Booking, type: :model do
  context "Validations" do
    it { should validate_presence_of(:client_email) }
    it { should allow_value("example@email.com").for(:client_email) }
    it { should_not allow_value("foo@bar").for(:client_email) }
    it { should_not allow_value("@bar.fu").for(:client_email) }
    it { should_not allow_value("foo.bar").for(:client_email) }

    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at) }

    it "should not allow end_at to be before start_at" do
      booking = build(:booking, start_at: DateTime.tomorrow, end_at: DateTime.yesterday)
      expect(booking.valid?).to be(false)
    end

    it "should not allow start_at to be in the past" do
      booking = build(:booking, start_at: DateTime.yesterday)
      expect(booking.valid?).to be(false)
    end

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }
    it { should_not allow_value(-1).for(:price) }
    it { should_not allow_value(1.5).for(:price) }
  end

  context "Associations" do
    it { should belong_to(:rental) }
  end

  context "Price" do
    it "should calculate prices correctly" do
      booking = create(:booking)
      expected = (booking.end_date - booking.start_date).to_i * booking.rental.daily_rate
      expect(booking.price).to eql(expected)
    end
  end

  context "Overlap" do
    before(:example) do
      @booking = create(:booking,
                        start_at: DateTime.tomorrow,
                        end_at: 10.days.from_now)
    end

    context "Other rental" do
      it "should allow overlap" do
        new_booking = build(:booking,
                            start_at: @booking.start_at,
                            end_at: @booking.end_at,
                            rental: create(:rental))
        expect(new_booking.valid?).to be(true)
      end
    end

    context "Same rental" do
      it "should not overlap with other at end" do
        new_booking = build(:booking,
                            start_at: @booking.end_at - 1.day,
                            rental: @booking.rental)
        expect(new_booking.valid?).to be(false)
      end

      it "should not overlap with other at start" do
        new_booking = build(:booking,
                            end_at: @booking.start_at + 1.day,
                            rental: @booking.rental)
        expect(new_booking.valid?).to be(false)
      end

      it "should not overlap with other in middle" do
        new_booking = build(:booking,
                            start_at: @booking.start_at + 1.day,
                            end_at: @booking.end_at - 1.day,
                            rental: @booking.rental)
        expect(new_booking.valid?).to be(false)
      end

      it "should not overlap with other from start to end" do
        new_booking = build(:booking,
                            start_at: @booking.start_at - 1.day,
                            end_at: @booking.end_at + 1.day,
                            rental: @booking.rental)
        expect(new_booking.valid?).to be(false)
      end
    end
  end

  describe "Minimum booking" do
    it "should allow one day booking" do
      booking = build(:booking, start_at: Date.tomorrow, end_at: 2.days.from_now)
      expect(booking.valid?).to be(true)
    end

    it "should not allow less than a day booking" do
      booking = build(:booking, start_at: Date.tomorrow, end_at: Date.tomorrow)
      expect(booking.valid?).to be(false)
    end
  end
end
