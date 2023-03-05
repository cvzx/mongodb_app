# frozen_string_literal: true

module Types
  include Dry.Types()
end

class Reservation < Dry::Struct
  transform_keys(&:to_sym)

  attribute :id, Types::Params::String.optional.default(nil)
  attribute :hotel_name, Types::Params::String
  attribute :price, Types::Params::Integer
  attribute :currency, Types::Params::String
  attribute :entry_date, Types::Params::DateTime
  attribute :departure_date, Types::Params::DateTime
  attribute :guest_name, Types::Params::String
  attribute :guest_email, Types::Params::String
end
