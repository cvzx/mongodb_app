# frozen_string_literal: true

FactoryBot.define do
  factory :mongodb_user, class: "Mongodb::Models::User" do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
