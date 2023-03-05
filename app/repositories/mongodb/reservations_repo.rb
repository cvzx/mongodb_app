# frozen_string_literal: true

module Mongodb
  class ReservationsRepo
    def all
      records = reservations.all

      records.map { |record| to_reservation(record) }
    end

    def find(id)
      record = reservations.find(id)

      to_reservation(record)
    end

    def create(attributes)
      created_record = reservations.create!(to_document(attributes))

      to_reservation(created_record)
    end

    def update(reservation, attributes)
      record = reservations.find(reservation.id)

      record.update_attributes!(to_document(attributes))

      to_reservation(record)
    end

    def delete(reservation)
      deleted_record_count = reservations.delete_all(id: reservation.id)

      deleted_record_count == 1
    end

    private

    def to_reservation(record)
      converter.to_reservation(record)
    end

    def to_document(attributes)
      reservation = Reservation.new(attributes)

      converter.to_mongodb_document(reservation)
    end

    def reservations
      Models::Reservation
    end

    def converter
      ReservationConverter
    end
  end
end
