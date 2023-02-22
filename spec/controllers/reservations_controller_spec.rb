# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReservationsController do
  let(:reservations_service_class) do
    class_double('ReservationsService', new: mock_reservations_service)
  end

  let(:mock_reservations_service) { double }

  before do
    reservations_service_class.as_stubbed_const
  end

  describe 'GET index' do
    let(:list_all_result) { double(:success, success?: true, result: reservations) }
    let(:reservations) { build_list(:reservation, 3) }

    before do
      allow(mock_reservations_service).to receive(:list_all).and_return(list_all_result)

      get :index
    end

    context 'when success' do
      it 'returns :ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns list of reservations' do
        expect(response.body).to include_json({ 'reservations' => reservations.map(&:as_json) })
      end
    end

    context 'when fails' do
      let(:list_all_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ['error1', 'error3', 'error3'] }

      it 'returns :unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns fetching errors' do
        expect(response.body).to include_json({ 'errors' => errors })
      end
    end
  end

  describe 'GET show' do
    let(:find_result) { double(:success, success?: true, result: reservation) }
    let(:reservation) { build(:reservation) }

    before do
      allow(mock_reservations_service).to receive(:find).and_return(find_result)

      get :show, params: { id: reservation.id }
    end

    context 'when success' do
      it 'returns :ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns reservation' do
        expect(response.body).to include_json({ 'reservation' => reservation.as_json })
      end
    end

    context 'when fails' do
      let(:find_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ['error1', 'error3', 'error3'] }

      it 'returns :unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns fetching errors' do
        expect(response.body).to include_json({ 'errors' => errors })
      end
    end
  end

  describe 'POST create' do
    let(:creating_result) { double(:success, success?: true, result: reservation) }
    let(:reservation) { build(:reservation) }

    before do
      allow(mock_reservations_service).to receive(:create)
        .and_return(creating_result)

      post :create, params: { reservation: reservation.attributes.except(:id) }
    end

    context 'when success' do
      it 'returns :ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns created reservation' do
        expect(response.body).to include_json({ 'reservation' => reservation.as_json })
      end
    end

    context 'when fails' do
      let(:creating_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ['error1', 'error2', 'error3'] }

      it 'returns :unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns creating errors' do
        expect(response.body).to include_json({ 'errors' => errors })
      end
    end
  end

  describe 'PUT update' do
    let(:updating_result) { double(:success, success?: true, result: reservation) }
    let(:reservation) { build(:reservation) }
    let(:update_params) { attributes_for(:reservation).except(:id) }

    before do
      allow(mock_reservations_service).to receive(:update).and_return(updating_result)

      put :update, params: { id: reservation.id, reservation: update_params }
    end

    context 'when success' do
      it 'returns :ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns updated reservation' do
        expect(response.body).to include_json({ 'reservation' => reservation.as_json })
      end
    end

    context 'when fails' do
      let(:updating_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ['error1', 'error2', 'error3'] }

      it 'returns :unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns updating errors' do
        expect(response.body).to include_json({ 'errors' => errors })
      end
    end
  end
  
  describe 'DELETE destroy' do
    let(:deleting_result) { double(:success, success?: true, result: nil) }

    before do
      allow(mock_reservations_service).to receive(:delete).and_return(deleting_result)

      put :destroy, params: {:id => 1}
    end

    context 'when success' do
      it 'returns :ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when fails' do
      let(:deleting_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ['error1', 'error2', 'error3'] }

      it 'returns :unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns updating errors' do
        expect(response.body).to include_json({ 'errors' => errors })
      end
    end
  end
end
