# frozen_string_literal: true

module Mongodb
  class ReservationConverter
    class << self
      def to_reservation(mongo_record)
        Reservation.new(
          id: mongo_record._id.to_s,
          hotel_name: mongo_record.hotel_name,
          price: mongo_record.price,
          currency: mongo_record.currency,
          entry_date: mongo_record.entry_date,
          departure_date: mongo_record.departure_date,
          guest_name: mongo_record.user.name,
          guest_email: mongo_record.user.email,
        )
      end

      def to_mongodb_document(reservation)
        document = {
          hotel_name: reservation.hotel_name,
          price: reservation.price,
          currency: reservation.currency,
          entry_date: reservation.entry_date,
          departure_date: reservation.departure_date,
          user: {
            name: reservation.guest_name,
            email: reservation.guest_email,
          },
        }

        document[:_id] = reservation.id if reservation.id
        document
      end
    end
  end
end
