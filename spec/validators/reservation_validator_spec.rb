# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ReservationValidator) do
  subject(:validator) { described_class.new }

  describe "#call" do
    subject(:validation) { validator.call(params) }

    let(:params) { attributes_for(:reservation) }

    context "when params are valid" do
      it "succeeds" do
        expect(validation).to(be_success)
      end
    end

    context "when price is not positive" do
      let(:params) { attributes_for(:reservation, price: -1) }

      it "fails" do
        expect(validation).not_to(be_success)
      end

      it "returns correct error" do
        expect(validation.errors.messages.to_s).to(include("Must be positive"))
      end
    end

    context "when email is invalid" do
      let(:params) { attributes_for(:reservation, guest_email: "wrong email") }

      it "fails" do
        expect(validation).not_to(be_success)
      end

      it "returns correct error" do
        expect(validation.errors.messages.to_s).to(include("Invalid email"))
      end
    end

    context "when departure_date is invalid" do
      let(:params) do
        attributes_for(
          :reservation,
          entry_date: DateTime.now,
          departure_date: DateTime.now - 1.day,
        )
      end

      it "fails" do
        expect(validation).not_to(be_success)
      end

      it "returns correct error" do
        expect(validation.errors.messages.to_s).to(include("Must be greater than entry date"))
      end
    end
  end
end
