require "rails_helper"

RSpec.describe Rental, type: :model do
  context "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:daily_rate) }
    it { should validate_numericality_of(:daily_rate) }
    it { should_not allow_value(-1).for(:daily_rate) }
    it { should_not allow_value(1.5).for(:daily_rate) }
  end

  context "Associations" do
    it { should have_many(:bookings) }
  end
end
