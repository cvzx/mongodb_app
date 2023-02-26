# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Reservation) do
  subject(:reservation) { described_class.new(attributes) }

  let(:attributes) { attributes_for(:reservation) }

  it "has correct attributes" do
    expect(reservation).to(have_attributes(attributes))
  end
end
