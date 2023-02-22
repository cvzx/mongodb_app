# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation do
  subject(:reservation) { described_class.new(attributes) }

  let(:attributes) do
    {
      id: 134,
      hotel_name: 'test hotel name',
      price: 123,
      currency: 'EUR',
      entry_date: DateTime.now.beginning_of_day,
      departure_date: DateTime.now + 2.days,
      guest_name: 'test guest name',
      guest_email: 'test guest email'
    }
  end

  it 'has correct attributes' do
    expect(reservation).to have_attributes(attributes)
  end
end
