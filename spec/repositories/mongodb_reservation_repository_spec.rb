# frozen_string_literal: true

require "rails_helper"

RSpec.describe(MongodbReservationRepository) do
  subject(:repo) { described_class.new }

  describe "#all" do
    let!(:mongo_records) { create_list(:mongodb_reservation, 5) }

    let(:expected_reservations) do
      mongo_records.map { |res| convert_to_mongo_record_to_reservation(res) }
    end

    it "returns list of mongodb reservation records" do
      expect(repo.all).to(eq(expected_reservations))
    end
  end

  describe "#find" do
    let!(:mongo_records) { create_list(:mongodb_reservation, 5) }
    let(:mongo_record) { mongo_records.sample }
    let(:id) { mongo_record.id }
    let(:expected_reservation) { convert_to_mongo_record_to_reservation(mongo_record) }

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

    let(:reservation) { build(:reservation) }
    let!(:mongo_record) { create(:mongodb_reservation, reservation.attributes) }
    let(:old_attributes) { reservation.attributes.except(:id) }
    let(:new_attributes) { attributes_for(:reservation).except(:id) }
    let(:updated_reservation) { build(:reservation, new_attributes.merge(id: reservation.id)) }

    it "updates existing record in mongodb" do
      expect(mongo_record).to(have_attributes(old_attributes))
      update
      expect(mongo_record.reload).to(have_attributes(new_attributes))
    end

    it "returns updated reservation" do
      expect(update).to(eq(updated_reservation))
    end
  end

  describe "#delete" do
    subject(:delete) { repo.delete(reservation) }

    let!(:mongo_records) { create_list(:mongodb_reservation, 5) }
    let(:reservation) { convert_to_mongo_record_to_reservation(mongo_records.sample) }

    it "deletes existing mongodb record" do
      expect { delete }.to(change { repo.all.count }.by(-1))
    end

    it "returns true" do
      expect(delete).to(be(true))
    end
  end

  private

  def convert_to_mongo_record_to_reservation(mongo_record)
    attrs = mongo_record.attributes.except("_id")
    attrs["id"] = mongo_record.id.to_s
    attrs["entry_date"] = mongo_record.entry_date.to_datetime
    attrs["departure_date"] = mongo_record.departure_date.to_datetime

    Reservation.new(attrs)
  end
end
