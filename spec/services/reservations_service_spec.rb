# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ReservationsService) do
  subject(:reservations_service) { described_class.new(repo:, validator:) }

  let(:repo) { instance_double(MongodbReservationRepository) }
  let(:validator) { instance_double(ReservationValidator) }
  let(:success) { instance_double(Resultable::Result, success?: true) }
  let(:failed) { instance_double(Resultable::Result, success?: false) }

  describe "#list_all" do
    subject(:fetch_all_reservations) { reservations_service.list_all }

    let(:reservations) { build_list(:reservation, 3) }

    before do
      allow(repo).to(receive(:all).and_return(reservations))
    end

    context "when success" do
      it "returns successful result" do
        expect(fetch_all_reservations).to(be_success)
      end

      it "returns list off all reservations" do
        expect(fetch_all_reservations.result).to(eq(reservations))
      end
    end

    context "when fails" do
      let(:error) { StandardError.new("test error") }

      before do
        allow(repo).to(receive(:all).and_raise(error))
      end

      it "returns failed result" do
        expect(fetch_all_reservations).not_to(be_success)
      end

      it "returns errors" do
        expect(fetch_all_reservations.errors).to(eq([error.message]))
      end
    end
  end

  describe "#find_by_id" do
    subject(:find_reservation) { reservations_service.find_by_id(id) }

    let(:id) { reservation.id }
    let(:reservation) { build(:reservation) }

    before do
      allow(repo).to(receive(:find).with(id).and_return(reservation))
    end

    context "when success" do
      it "returns successful result" do
        expect(find_reservation).to(be_success)
      end

      it "returns reservation" do
        expect(find_reservation.result).to(eq(reservation))
      end
    end

    context "when fails" do
      let(:error) { StandardError.new("test error") }

      before do
        allow(repo).to(receive(:find).and_raise(error))
      end

      it "returns failed result" do
        expect(find_reservation).not_to(be_success)
      end

      it "returns errors" do
        expect(find_reservation.errors).to(eq([error.message]))
      end
    end
  end

  describe "#create" do
    subject(:create_reservation) do
      reservations_service.create(attributes)
    end

    let(:attributes) { attributes_for(:reservation) }
    let(:reservation) { build(:reservation, attributes) }

    before do
      allow(repo).to(receive(:create).and_return(reservation))
    end

    context "when attributes valid" do
      before do
        allow(validator).to(receive(:call).and_return(success))
      end

      it "creates reservation in repository" do
        create_reservation

        expect(repo).to(have_received(:create).with(attributes))
      end

      context "when creation success" do
        before do
          allow(repo).to(receive(:create).and_return(reservation))
        end

        it "succeeds" do
          expect(create_reservation).to(be_success)
        end

        it "returns created reservation" do
          expect(create_reservation.result).to(have_attributes(attributes))
        end
      end

      context "when creation fails" do
        let(:error) { StandardError.new("test error") }

        before do
          allow(repo).to(receive(:create).and_raise(error))
        end

        it "fails" do
          expect(create_reservation).not_to(be_success)
        end

        it "returns creation errors" do
          expect(create_reservation.errors).to(eq([error.message]))
        end
      end
    end

    context "when attributes invalid" do
      let(:validation_errors) { ["error1", "error2"] }

      before do
        allow(failed).to(receive(:errors).and_return(validation_errors))
        allow(validator).to(receive(:call).and_return(failed))
      end

      it "fails" do
        expect(create_reservation).not_to(be_success)
      end

      it "returns validation errors" do
        expect(create_reservation.errors).to(eq([validation_errors.join(", ")]))
      end
    end
  end

  describe "#update" do
    subject(:update_reservation) { reservations_service.update(id, new_attributes) }

    let(:id) { SecureRandom.uuid }
    let(:old_attributes) { attributes_for(:reservation).merge(id:) }
    let(:new_attributes) { attributes_for(:reservation) }
    let(:reservation) { build(:reservation, old_attributes) }
    let(:updated_reservation) { build(:reservation, new_attributes) }

    before do
      allow(repo).to(receive(:find).with(id).and_return(reservation))
      allow(repo).to(receive(:update).and_return(updated_reservation))
    end

    context "when attributes valid" do
      before do
        allow(validator).to(receive(:call).and_return(success))
      end

      it "updates reservation in repository" do
        update_reservation

        expect(repo).to(have_received(:update).with(reservation, new_attributes))
      end

      context "when success" do
        it "returns successful result" do
          expect(update_reservation).to(be_success)
        end

        it "returns updated reservation" do
          expect(update_reservation.result).to(have_attributes(new_attributes))
        end
      end

      context "when fails" do
        let(:error) { StandardError.new("test error") }

        before do
          allow(repo).to(receive(:update).and_raise(error))
        end

        it "returns failed result" do
          expect(update_reservation).not_to(be_success)
        end

        it "returns errors" do
          expect(update_reservation.errors).to(eq([error.message]))
        end
      end
    end

    context "when attributes invalid" do
      let(:validation_errors) { ["error1", "error2"] }

      before do
        allow(failed).to(receive(:errors).and_return(validation_errors))
        allow(validator).to(receive(:call).and_return(failed))
      end

      it "fails" do
        expect(update_reservation).not_to(be_success)
      end

      it "returns validation errors" do
        expect(update_reservation.errors).to(eq([validation_errors.join(", ")]))
      end
    end
  end

  describe "#delete" do
    subject(:delete_reservation) { reservations_service.delete(id) }

    let(:id) { SecureRandom.uuid }
    let(:reservation) { build(:reservation, id:) }

    before do
      allow(repo).to(receive(:find).with(id).and_return(reservation))
      allow(repo).to(receive(:delete).and_return(true))
    end

    it "deletes reservation in repository" do
      delete_reservation

      expect(repo).to(have_received(:delete).with(reservation))
    end

    context "when success" do
      it "returns successful result" do
        expect(delete_reservation).to(be_success)
      end

      it "returns true" do
        expect(delete_reservation.result).to(be(true))
      end
    end

    context "when fails" do
      let(:error) { StandardError.new("test error") }

      before do
        allow(repo).to(receive(:delete).and_raise(error))
      end

      it "returns failed result" do
        expect(delete_reservation).not_to(be_success)
      end

      it "returns errors" do
        expect(delete_reservation.errors).to(eq([error.message]))
      end
    end
  end
end
