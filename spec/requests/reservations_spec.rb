# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Reservations") do
  let(:reservations) { build_list(:reservation, 5) }

  before do
    reservations.each { |res| create(:mongodb_reservation, res.attributes) }
  end

  describe "GET /api/reservations" do
    let(:expected_reservations) do
      reservations
        .as_json(only: [:hotel_name, :price, :entry_date, :departure_date, :guest_name])
    end

    it "returns list of reservations" do
      get "/api/reservations"

      expect(response).to(have_http_status(:success))
      expect(response.body).to(include_json(expected_reservations))
    end
  end

  describe "GET /api/reservations/:id" do
    let(:reservation) { reservations.sample }
    let(:id) { reservation.id }

    let(:expected_reservation) do
      reservation.attributes
        .as_json(only: [:hotel_name, :price, :entry_date, :departure_date, :guest_name])
    end

    it "returns reservation" do
      get "/api/reservations/#{id}"

      expect(response).to(have_http_status(:success))
      expect(response.body).to(include_json(expected_reservation))
    end
  end

  describe "POST /api/reservations" do
    let(:create_params) { attributes_for(:reservation).except(:id) }
    let(:params) { { reservation: create_params } }

    let(:expected_reservation) do
      params.as_json(only: [:hotel_name, :price, :entry_date, :departure_date, :guest_name])
    end

    it "returns created reservation" do
      post "/api/reservations", params: params

      expect(response).to(have_http_status(:success))
      expect(response.body).to(include_json(expected_reservation))
    end
  end

  describe "PUT /api/reservations/:id" do
    let(:id) { reservations.first.id }
    let(:params) { { reservation: attributes_for(:reservation).except(:id) } }

    let(:expected_reservation) do
      params.as_json(only: [:hotel_name, :price, :entry_date, :departure_date, :guest_name])
    end

    it "returns updated reservation" do
      put "/api/reservations/#{id}", params: params

      expect(response).to(have_http_status(:success))
      expect(response.body).to(include_json(expected_reservation))
    end
  end

  describe "DELETE /api/reservations/:id" do
    let(:id) { reservations.first.id }

    it "returns head :ok" do
      delete "/api/reservations/#{id}"

      expect(response).to(have_http_status(:success))
    end
  end
end
