# frozen_string_literal: true

require "rails_helper"

RSpec.describe(MongodbReservationRepository) do
  subject(:repo) { described_class.new }

  describe "#all" do
    let!(:mongo_records) { create_list(:mongodb_reservation, 5) }

    let(:expected_reservations) do
      mongo_records.map { |res| to_reservation(res) }
    end

    it "returns list of mongodb reservation records" do
      expect(repo.all).to(eq(expected_reservations))
    end
  end

  describe "#find" do
    let!(:mongo_records) { create_list(:mongodb_reservation, 5) }
    let(:mongo_record) { mongo_records.sample }
    let(:id) { mongo_record.id }
    let(:expected_reservation) { to_reservation(mongo_record) }

    it "returns reservation found by id" do
      expect(repo.find(id)).to(eq(expected_reservation))
    end
  end

  describe "#create" do
    subject(:create) { repo.create(attributes) }

    let(:attributes) { attributes_for(:reservation) }
    let(:created_reservation) { Reservation.new(attributes) }

    it "created new record in mongodb" do
      expect { create }.to(change { repo.all.count }.by(1))
    end

    it "returns created reservation" do
      expect(create).to(eq(created_reservation))
    end
  end

  describe "#update" do
    subject(:update) { repo.update(reservation, new_attributes) }

    let!(:mongo_record) { create(:mongodb_reservation) }
    let(:reservation) { to_reservation(mongo_record) }
    let(:new_attributes) { attributes_for(:reservation).except(:id) }
    let(:new_mongo_attributes) { to_mongo_attrs(new_attributes) }
    let(:updated_reservation) { build(:reservation, new_attributes.merge(id: reservation.id)) }

    it "updates existing record in mongodb" do
      update

      expect(mongo_record.reload).to(have_attributes(new_mongo_attributes.except(:user)))
      expect(mongo_record.user).to(have_attributes(new_mongo_attributes.fetch(:user)))
    end

    it "returns updated reservation" do
      expect(update).to(eq(updated_reservation))
    end
  end

  describe "#delete" do
    subject(:delete) { repo.delete(reservation) }

    let!(:mongo_records) { create_list(:mongodb_reservation, 5) }
    let(:reservation) { to_reservation(mongo_records.sample) }

    it "deletes existing mongodb record" do
      expect { delete }.to(change { repo.all.count }.by(-1))
    end

    it "returns true" do
      expect(delete).to(be(true))
    end
  end

  private

  def to_reservation(mongo_record)
    attributes = mongo_record.attributes.except("_id", "user")
    attributes["id"] = mongo_record.id.to_s
    attributes["entry_date"] = mongo_record.entry_date.to_datetime
    attributes["departure_date"] = mongo_record.departure_date.to_datetime
    attributes["guest_name"] = mongo_record.user.name
    attributes["guest_email"] = mongo_record.user.email

    Reservation.new(attributes)
  end

  def to_mongo_attrs(attrs)
    attributes = attrs.except(:guest_name, :guest_email)
    attributes[:user] = { name: attrs[:guest_name], email: attrs[:guest_email] }

    attributes
  end
end
