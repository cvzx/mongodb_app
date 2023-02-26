# frozen_string_literal: true

class HtmlReservationPresenter < BasicPresenter
  delegate :id, :hotel_name, :price, :entry_date, :departure_date, :guest_name, to: :@object
end

