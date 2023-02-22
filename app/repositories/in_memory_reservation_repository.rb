# frozen_string_literal: true

class InMemoryReservationRepository
  def initialize
    @reservations = FactoryBot.build_list(:reservation, 5)
  end

  def all
    @reservations
  end

  def find(id)
    @reservations.find { |res| res.id == id }
  end

  def create(attributes)
    reservation = Reservation.new(attributes.merge(id: @reservations.last.id + 1))

    @reservations << reservation
  end

  def update(id, attributes)
    reservation = find(id)

    updated_reservation = Reservation.new(reservation.attributes.merge(attributes))
    @reservations[@reservations.index(reservation)] = updated_reservation
  end

  def delete(id)
    reservation = find(id)

    @reservations.delete(reservation)

    true
  end
end
