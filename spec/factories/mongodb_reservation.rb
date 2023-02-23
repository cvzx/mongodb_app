# frozen_string_literal: true

FactoryBot.define do
  factory :mongodb_reservation, class: 'MongodbReservationRepository' do
    id { SecureRandom.uuid }
    hotel_name { Faker::Company.name }
    price { rand(1..10_000) }
    currency { 'EUR' }
    entry_date { DateTime.now.beginning_of_day }
    departure_date { DateTime.now.beginning_of_day + 2.days }
    guest_name { Faker::Name.name }
    guest_email { Faker::Internet.email }
  end
end
