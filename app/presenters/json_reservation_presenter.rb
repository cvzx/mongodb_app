# frozen_string_literal: true

class JsonReservationPresenter
  def initialize(reservation)
    @reservation = reservation
  end

  delegate :hotel_name, :price, :entry_date, :departure_date, :guest_name, to: :@reservation

  def as_json(_)
    { hotel_name:, price:, entry_date:, departure_date:, guest_name: }
  end
end
