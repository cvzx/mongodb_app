# frozen_string_literal: true

class MongodbReservationRepository
  include Mongoid::Document

  field :hotel_name, type: String
  field :price, type: Integer
  field :currency, type: String
  field :entry_date, type: DateTime
  field :departure_date, type: DateTime
  field :guest_name, type: String
  field :guest_email, type: String

  def all
    records = self.class.all

    records.map { |record| convert_mongo_record_to_reservation(record) }
  end

  def find(id)
    record = self.class.find(id)

    convert_mongo_record_to_reservation(record)
  end

  def create(attributes)
    created_record = self.class.create!(attributes)

    convert_mongo_record_to_reservation(created_record)
  end

  def update(reservation, attributes)
    record = self.class.find(reservation.id)

    record.update_attributes!(attributes)

    convert_mongo_record_to_reservation(record)
  end

  def delete(reservation)
    deleted_record_count = self.class.delete_all(id: reservation.id)

    deleted_record_count == 1
  end

  private

  def convert_mongo_record_to_reservation(record)
    attributes = record.attributes.except("_id")
    attributes["id"] = record.id.to_s
    attributes["entry_date"] = record.entry_date.to_datetime
    attributes["departure_date"] = record.departure_date.to_datetime

    Reservation.new(attributes)
  end
end
