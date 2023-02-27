# frozen_string_literal: true

FactoryBot.define do
  factory :mongodb_reservation, class: "MongodbReservationRepository::Reservation" do
    id { SecureRandom.uuid }
    hotel_name { Faker::Company.name }
    price { rand(1..10_000) }
    currency { "EUR" }
    entry_date { DateTime.now.beginning_of_day }
    departure_date { DateTime.now.beginning_of_day + 2.days }
    user { FactoryBot.build(:mongodb_user) }
  end
end
