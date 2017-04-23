FactoryGirl.define do
  factory :booking do
    client_email { Faker::Internet.email }
    sequence(:start_at) { |n| n.days.from_now }
    sequence(:end_at, 2) { |n| n.days.from_now }
    rental
  end
end
