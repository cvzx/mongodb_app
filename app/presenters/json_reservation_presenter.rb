# frozen_string_literal: true

class JsonReservationPresenter
  def initialize(reservation)
    @reservation = reservation
  end

  delegate :hotel_name, :price, :entry_date, :departure_date, :guest_name, to: :@reservation

  def as_json(_)
    { hotel_name:, price:, entry_date:, departure_date:, guest_name: }
  end

  def self.present(item)
    new(item)
  end

  def self.present_collection(collection)
    collection.map { |item| present(item) }
  end
end
