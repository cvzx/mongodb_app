# frozen_string_literal: true

class InMemoryReservationRepository
  def initialize(reservations: nil)
    @reservations = reservations || FactoryBot.build_list(:reservation, 5)
  end

  def all
    @reservations
  end

  def find(id)
    @reservations.find { |res| res.id == id.to_i }
  end

  def create(attributes)
    reservation = Reservation.new(attributes.merge(id: @reservations.last.id + 1))

    @reservations << reservation

    reservation
  end

  def update(reservation, attributes)
    updated_reservation = Reservation.new(reservation.attributes.merge(attributes))
    @reservations[@reservations.index(reservation)] = updated_reservation

    updated_reservation
  end

  def delete(reservation)
    @reservations.delete(reservation)

    true
  end
end
