# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    sequence :id do |n|
      n
    end

    hotel_name { Faker::Company.name }
    price { rand(1..10_000) }
    currency { 'EUR' }
    entry_date { DateTime.now.beginning_of_day }
    departure_date { DateTime.now + 2.days }
    guest_name { Faker::Name.name }
    guest_email { Faker::Internet.email }

    initialize_with { new(**attributes) }
  end
end
