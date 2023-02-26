# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ReservationsController) do
  let(:mock_service) { double }

  let(:mock_presenter) { double(new: presented_reservation) }
  let(:presented_reservation) { "presented_reservation" }

  before do
    allow_any_instance_of(described_class).to(receive(:reservations_service)
      .and_return(mock_service))
    allow_any_instance_of(described_class).to(receive(:presenter).and_return(mock_presenter))
  end

  describe "GET index" do
    let(:list_all_result) { double(:success, success?: true, result: reservations) }
    let(:reservations) { build_list(:reservation, 3) }
    let(:presented_reservations) { reservations.map { |res| { id: res.id } } }

    before do
      allow(mock_service).to(receive(:list_all).and_return(list_all_result))

      reservations.each do |res|
        allow(mock_presenter).to(receive(:new).with(res).and_return({ id: res.id }))
      end

      get :index
    end

    context "when success" do
      it "returns :ok status" do
        expect(response).to(have_http_status(:ok))
      end

      it "returns list of reservations" do
        expect(response.body).to(include_json(presented_reservations))
      end
    end

    context "when fails" do
      let(:list_all_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ["error1", "error3", "error3"] }

      it "returns :unprocessable_entity status" do
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it "returns fetching errors" do
        expect(response.body).to(include_json({ "errors" => errors }))
      end
    end
  end

  describe "GET show" do
    let(:find_result) { double(:success, success?: true, result: reservation) }
    let(:reservation) { build(:reservation) }
    let(:presented_reservation) { { id: reservation.id } }

    before do
      allow(mock_service).to(receive(:find_by_id).with(reservation.id).and_return(find_result))
      allow(mock_presenter).to(receive(:new).with(reservation).and_return(presented_reservation))

      get :show, params: { id: reservation.id }
    end

    context "when success" do
      it "returns :ok status" do
        expect(response).to(have_http_status(:ok))
      end

      it "returns reservation" do
        expect(response.body).to(include_json(presented_reservation))
      end
    end

    context "when fails" do
      let(:find_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ["error1", "error3", "error3"] }

      it "returns :unprocessable_entity status" do
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it "returns fetching errors" do
        expect(response.body).to(include_json({ "errors" => errors }))
      end
    end
  end

  describe "POST create" do
    let(:creating_result) { double(:success, success?: true, result: reservation) }
    let(:reservation) { build(:reservation) }
    let(:presented_reservation) { { id: reservation.id } }

    before do
      allow(mock_service).to(receive(:create).and_return(creating_result))
      allow(mock_presenter).to(receive(:new).with(reservation).and_return(presented_reservation))

      post :create, params: { reservation: reservation.attributes.except(:id) }
    end

    context "when success" do
      it "returns :ok status" do
        expect(response).to(have_http_status(:ok))
      end

      it "returns created reservation" do
        expect(response.body).to(include_json(presented_reservation))
      end
    end

    context "when fails" do
      let(:creating_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ["error1", "error2", "error3"] }

      it "returns :unprocessable_entity status" do
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it "returns creating errors" do
        expect(response.body).to(include_json({ "errors" => errors }))
      end
    end
  end

  describe "PUT update" do
    let(:update_params) { attributes_for(:reservation).except(:id) }
    let(:updating_result) { double(:success, success?: true, result: reservation) }
    let(:reservation) { build(:reservation) }
    let(:presented_reservation) { { id: reservation.id } }

    before do
      allow(mock_service).to(receive(:update).and_return(updating_result))
      allow(mock_presenter).to(receive(:new).with(reservation).and_return(presented_reservation))

      put :update, params: { id: reservation.id, reservation: update_params }
    end

    context "when success" do
      it "returns :ok status" do
        expect(response).to(have_http_status(:ok))
      end

      it "returns updated reservation" do
        expect(response.body).to(include_json(presented_reservation))
      end
    end

    context "when fails" do
      let(:updating_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ["error1", "error2", "error3"] }

      it "returns :unprocessable_entity status" do
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it "returns updating errors" do
        expect(response.body).to(include_json({ "errors" => errors }))
      end
    end
  end

  describe "DELETE destroy" do
    let(:deleting_result) { double(:success, success?: true, result: nil) }

    before do
      allow(mock_service).to(receive(:delete).and_return(deleting_result))

      put :destroy, params: { id: 1 }
    end

    context "when success" do
      it "returns :ok status" do
        expect(response).to(have_http_status(:ok))
      end
    end

    context "when fails" do
      let(:deleting_result) { double(:fail, success?: false, errors: errors) }
      let(:errors) { ["error1", "error2", "error3"] }

      it "returns :unprocessable_entity status" do
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it "returns updating errors" do
        expect(response.body).to(include_json({ "errors" => errors }))
      end
    end
  end
end
