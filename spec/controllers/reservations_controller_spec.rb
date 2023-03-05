# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ReservationsController) do
  let(:mock_service) { instance_double(ReservationsService) }
  let(:mock_presenter) { class_double(JsonReservationPresenter) }
  let(:presented_reservation) { "presented_reservation" }

  before do
    allow_any_instance_of(described_class).to(receive(:reservations_service)
      .and_return(mock_service))
    allow_any_instance_of(described_class).to(receive(:json_presenter).and_return(mock_presenter))
  end

  shared_examples "a success" do
    it "returns :ok status" do
      expect(response).to(have_http_status(:ok))
    end

    it "returns expected content" do
      expect(response.body).to(include_json(expected_content))
    end
  end

  shared_examples "a fail" do
    it "returns :unprocessable_entity status" do
      expect(response).to(have_http_status(:unprocessable_entity))
    end

    it "returns fetching errors" do
      expect(response.body).to(include_json({ "errors" => errors }))
    end
  end

  describe "GET index" do
    let(:reservations) { build_list(:reservation, 3) }
    let(:presented_reservations) { reservations.map { |res| { id: res.id } } }

    let(:list_all_result) do
      instance_double(ReservationsService::Result, success?: true, result: reservations)
    end

    before do
      allow(mock_service).to(receive(:list_all).and_return(list_all_result))
      allow(mock_presenter).to(receive(:present).with(reservations)
        .and_return(presented_reservations))

      get :index, format: :json
    end

    context "when success" do
      let(:expected_content) { presented_reservations }

      it_behaves_like "a success"
    end

    context "when fails" do
      let(:errors) { ["error1", "error3", "error3"] }

      let(:list_all_result) do
        instance_double(ReservationsService::Result, success?: false, errors: errors)
      end

      it_behaves_like "a fail"
    end
  end

  describe "GET show" do
    let(:reservation) { build(:reservation) }
    let(:presented_reservation) { { id: reservation.id } }

    let(:find_result) do
      instance_double(ReservationsService::Result, success?: true, result: reservation)
    end

    before do
      allow(mock_service).to(receive(:find_by_id).with(reservation.id).and_return(find_result))
      allow(mock_presenter).to(receive(:present)
        .with(reservation)
        .and_return(presented_reservation))

      get :show, params: { id: reservation.id }, format: :json
    end

    context "when success" do
      let(:expected_content) { presented_reservation }

      it_behaves_like "a success"
    end

    context "when fails" do
      let(:errors) { ["error1", "error3", "error3"] }

      let(:find_result) do
        instance_double(ReservationsService::Result, success?: false, errors: errors)
      end

      it_behaves_like "a fail"
    end
  end

  describe "POST create" do
    let(:reservation) { build(:reservation) }
    let(:presented_reservation) { { id: reservation.id } }

    let(:creating_result) do
      instance_double(ReservationsService::Result, success?: true, result: reservation)
    end

    before do
      allow(mock_service).to(receive(:create).and_return(creating_result))
      allow(mock_presenter).to(receive(:present)
        .with(reservation)
        .and_return(presented_reservation))

      post :create, params: { reservation: reservation.attributes.except(:id) }, format: :json
    end

    context "when success" do
      let(:expected_content) { presented_reservation }

      it_behaves_like "a success"
    end

    context "when fails" do
      let(:errors) { ["error1", "error2", "error3"] }

      let(:creating_result) do
        instance_double(ReservationsService::Result, success?: false, errors: errors)
      end

      it_behaves_like "a fail"
    end
  end

  describe "PUT update" do
    let(:update_params) { attributes_for(:reservation).except(:id) }
    let(:reservation) { build(:reservation) }
    let(:presented_reservation) { { id: reservation.id } }

    let(:updating_result) do
      instance_double(ReservationsService::Result, success?: true, result: reservation)
    end

    before do
      allow(mock_service).to(receive(:update).and_return(updating_result))
      allow(mock_presenter).to(receive(:present)
        .with(reservation)
        .and_return(presented_reservation))

      put :update, params: { id: reservation.id, reservation: update_params }, format: :json
    end

    context "when success" do
      let(:expected_content) { presented_reservation }

      it_behaves_like "a success"
    end

    context "when fails" do
      let(:errors) { ["error1", "error2", "error3"] }

      let(:updating_result) do
        instance_double(ReservationsService::Result, success?: false, errors: errors)
      end

      it_behaves_like "a fail"
    end
  end

  describe "DELETE destroy" do
    let(:deleting_result) do
      instance_double(ReservationsService::Result, success?: true, result: nil)
    end

    before do
      allow(mock_service).to(receive(:delete).and_return(deleting_result))

      put :destroy, params: { id: 1 }, format: :json
    end

    context "when success" do
      it "returns :ok status" do
        expect(response).to(have_http_status(:ok))
      end
    end

    context "when fails" do
      let(:errors) { ["error1", "error2", "error3"] }

      let(:deleting_result) do
        instance_double(ReservationsService::Result, success?: false, errors: errors)
      end

      it_behaves_like "a fail"
    end
  end
end
