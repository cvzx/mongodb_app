require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:reservations) { build_list(:reservation, 5) }

  before do
    reservations.each { |res| create(:mongodb_reservation, res.attributes) }
  end

  describe 'GET /reservations' do
    let(:expected_reservations) { reservations.as_json }

    it 'returns list of reservations' do
      get '/reservations'

      expect(response).to have_http_status(:success)
      expect(response.body).to include_json('reservations' => expected_reservations)
    end
  end

  describe 'GET /reservations/:id' do
    let(:reservation) { reservations.sample }
    let(:id) { reservation.id }
    let(:expected_reservation) { reservation.attributes.as_json }

    it 'returns reservation' do
      get "/reservations/#{id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include_json('reservation' => expected_reservation)
    end
  end

  describe "POST /reservations" do
    let(:create_params) { attributes_for(:reservation).except(:id) }
    let(:params) { { reservation: create_params } }

    it "returns created reservation" do
      post '/reservations', params: params

      expect(response).to have_http_status(:success)
      expect(response.body).to include_json(params.as_json)
    end
  end

  describe "PUT /reservations/:id" do
    let(:id) { reservations.first.id }
    let(:params) { { reservation: attributes_for(:reservation).except(:id) } }

    it "returns updated reservation" do
      put "/reservations/#{id}", params: params

      expect(response).to have_http_status(:success)
      expect(response.body).to include_json(params.as_json)
    end
  end

  describe "DELETE /reservations/:id" do
    let(:id) { reservations.first.id }

    it "returns head :ok" do
      delete "/reservations/#{id}"

      expect(response).to have_http_status(:success)
    end
  end
end
