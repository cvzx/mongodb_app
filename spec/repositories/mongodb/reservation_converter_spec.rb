# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Mongodb::ReservationConverter) do
  subject(:converter) { described_class }

  describe "#to_reservation" do
    subject(:convert_to_reservation) { converter.to_reservation(mongo_record) }

    let(:mongo_record) { create(:mongodb_reservation) }

    let(:reservation) do
      Reservation.new(
        id: mongo_record._id,
        hotel_name: mongo_record.hotel_name,
        price: mongo_record.price,
        currency: mongo_record.currency,
        entry_date: mongo_record.entry_date,
        departure_date: mongo_record.departure_date,
        guest_name: mongo_record.user.name,
        guest_email: mongo_record.user.email,
      )
    end

    it "returns reservation" do
      expect(convert_to_reservation).to(eq(reservation))
    end
  end

  describe "#to_mongodb_document" do
    subject(:convert_to_mongodb_document) { converter.to_mongodb_document(reservation) }

    let(:reservation) { build(:reservation) }

    let(:mongodb_document) do
      {
        _id: reservation.id,
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
    end

    it "returns mongodb document" do
      expect(convert_to_mongodb_document).to(eq(mongodb_document))
    end
  end
end
