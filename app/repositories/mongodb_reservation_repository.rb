# frozen_string_literal: true

class MongodbReservationRepository
  class Reservation
    include Mongoid::Document

    field :hotel_name, type: String
    field :price, type: Integer
    field :currency, type: String
    field :entry_date, type: DateTime
    field :departure_date, type: DateTime

    embeds_one :user
  end

  class User
    include Mongoid::Document

    field :name, type: String
    field :email, type: String

    embedded_in :reservation
  end

  def all
    records = reservations.all

    records.map { |record| to_reservation(record) }
  end

  def find(id)
    record = reservations.find(id)

    to_reservation(record)
  end

  def create(attributes)
    created_record = reservations.create!(to_mongo_attrs(attributes))

    to_reservation(created_record)
  end

  def update(reservation, attributes)
    record = reservations.find(reservation.id)

    record.update_attributes!(to_mongo_attrs(attributes))

    to_reservation(record)
  end

  def delete(reservation)
    deleted_record_count = reservations.delete_all(id: reservation.id)

    deleted_record_count == 1
  end

  private

  def reservations
    self.class::Reservation
  end

  def to_reservation(record)
    attributes = record.attributes.except("_id", "user")
    attributes["id"] = record.id.to_s
    attributes["entry_date"] = record.entry_date.to_datetime
    attributes["departure_date"] = record.departure_date.to_datetime
    attributes["guest_name"] = record.user.name
    attributes["guest_email"] = record.user.email

    ::Reservation.new(attributes)
  end

  def to_mongo_attrs(attrs)
    attributes = attrs.except(:guest_name, :guest_email)
    attributes[:user] = { name: attrs[:guest_name], email: attrs[:guest_email] }

    attributes
  end
end
