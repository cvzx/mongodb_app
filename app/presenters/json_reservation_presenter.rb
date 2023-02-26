# frozen_string_literal: true

class JsonReservationPresenter < BasicPresenter
  delegate :id, :hotel_name, :price, :currency, :entry_date, :departure_date,
    :guest_name, to: :@object

  def as_json(_)
    {
      id:,
      hotel_name:,
      price:,
      currency:,
      entry_date:,
      departure_date:,
      guest_name:
    }
  end
end
