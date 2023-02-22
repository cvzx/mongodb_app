# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReservationsService do
  subject(:reservations_service) { described_class.new(repo) }

  let(:repo) do
    double(all: [1, 2, 3], create: nil)
  end

  describe '#list_all' do
    subject(:fetch_all_reservations) { reservations_service.list_all }

    context 'when success' do
      it 'returns successful result' do
        expect(fetch_all_reservations).to be_success
      end

      it 'returns list off all reservations' do
        expect(fetch_all_reservations.result).to eq([1, 2, 3])
      end
    end

    context 'when fails' do
      let(:error) { StandardError.new('test error') }

      before do
        allow(repo).to receive(:all).and_raise(error)
      end

      it 'returns failed result' do
        expect(fetch_all_reservations).not_to be_success
      end

      it 'returns errors' do
        expect(fetch_all_reservations.errors).to eq([error.message])
      end
    end
  end

  describe '#create' do
    subject(:create_reservation) { reservations_service.create(attributes) }

    let(:attributes) do
      {
        hotel_name: 'test hotel',
        price: 1234,
        guest_name: 'test guest'
      }
    end

    it 'creates reservation in repository' do
      create_reservation

      expect(repo).to have_received(:create).with(attributes)
    end

    context 'when success' do
      before do
        allow(repo).to receive(:create).and_return(reservation)
      end

      let(:reservation) { double(attributes) }

      it 'returns successful result' do
        expect(create_reservation).to be_success
      end

      it 'returns created reservation' do
        expect(create_reservation.result).to have_attributes(attributes)
      end
    end

    context 'when fails' do
      let(:error) { StandardError.new('test error') }

      before do
        allow(repo).to receive(:create).and_raise(error)
      end

      it 'returns failed result' do
        expect(create_reservation).not_to be_success
      end

      it 'returns errors' do
        expect(create_reservation.errors).to eq([error.message])
      end
    end
  end

  describe '#update' do
    subject(:update_reservation) { reservations_service.update(id, new_attributes) }

    let(:id) { 123 }

    let(:reservation) { double(old_attributes) }
    let(:updated_reservation) { double(new_attributes) }

    let(:old_attributes) do
      {
        id:,
        hotel_name: 'test',
        price: 111,
        guest_name: 'test'
      }
    end

    let(:new_attributes) do
      {
        hotel_name: 'test hotel',
        price: 1234,
        guest_name: 'test guest'
      }
    end

    before do
      allow(repo).to receive(:find).with(id).and_return(reservation)
      allow(repo).to receive(:update).and_return(updated_reservation)
    end

    it 'updates reservation in repository' do
      update_reservation

      expect(repo).to have_received(:update).with(reservation, new_attributes)
    end

    context 'when success' do
      it 'returns successful result' do
        expect(update_reservation).to be_success
      end

      it 'returns updated reservation' do
        expect(update_reservation.result).to have_attributes(new_attributes)
      end
    end

    context 'when fails' do
      let(:error) { StandardError.new('test error') }

      before do
        allow(repo).to receive(:update).and_raise(error)
      end

      it 'returns failed result' do
        expect(update_reservation).not_to be_success
      end

      it 'returns errors' do
        expect(update_reservation.errors).to eq([error.message])
      end
    end
  end

  describe '#delete' do
    subject(:delete_reservation) { reservations_service.delete(id) }

    let(:id) { 123 }
    let(:reservation) { double(attributes) }

    let(:attributes) do
      {
        id:,
        hotel_name: 'test hotel',
        price: 1234,
        guest_name: 'test guest'
      }
    end

    before do
      allow(repo).to receive(:find).with(id).and_return(reservation)
      allow(repo).to receive(:delete).and_return(true)
    end

    it 'deletes reservation in repository' do
      delete_reservation

      expect(repo).to have_received(:delete).with(reservation)
    end

    context 'when success' do
      it 'returns successful result' do
        expect(delete_reservation).to be_success
      end

      it 'returns true' do
        expect(delete_reservation.result).to be true
      end
    end

    context 'when fails' do
      let(:error) { StandardError.new('test error') }

      before do
        allow(repo).to receive(:delete).and_raise(error)
      end

      it 'returns failed result' do
        expect(delete_reservation).not_to be_success
      end

      it 'returns errors' do
        expect(delete_reservation.errors).to eq([error.message])
      end
    end
  end
end
