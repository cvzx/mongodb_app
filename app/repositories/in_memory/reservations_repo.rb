# frozen_string_literal: true

module InMemory
  class ReservationsRepo
    def initialize(reservations: [])
      @reservations = reservations
    end

    def all
      @reservations
    end

    def find(id)
      @reservations.find { |res| res.id == id }
    end

    def create(attributes)
      reservation = Reservation.new(attributes.merge(id: SecureRandom.uuid))

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
end
