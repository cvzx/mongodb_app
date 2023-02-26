# frozen_string_literal: true

class HtmlReservationPresenter < BasicPresenter
  delegate :id, :hotel_name, :price, :currency, :entry_date, :departure_date,
    :guest_name, :guest_email, to: :@object
end

