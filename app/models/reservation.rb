# frozen_string_literal: true

class Reservation < Dry::Struct
  attribute :id, 'integer'
  attribute :hotel_name, 'string'
  attribute :price, 'integer'
  attribute :currency, 'string'
  attribute :entry_date, 'date_time'
  attribute :departure_date, 'date_time'
  attribute :guest_name, 'string'
  attribute :guest_email, 'string'
end
