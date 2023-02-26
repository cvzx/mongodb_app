# frozen_string_literal: true

class HtmlReservationPresenter < BasicPresenter
  delegate :id, :hotel_name, :price, :currency, :guest_name, :guest_email, to: :@object

  def entry_date
    @object.entry_date.strftime("%Y-%m-%d")
  end

  def departure_date
    @object.departure_date.strftime("%Y-%m-%d")
  end
end
