# frozen_string_literal: true

module Mongodb
  module Models
    class Reservation
      include Mongoid::Document

      field :hotel_name, type: String
      field :price, type: Integer
      field :currency, type: String
      field :entry_date, type: DateTime
      field :departure_date, type: DateTime

      embeds_one :user
    end
  end
end
