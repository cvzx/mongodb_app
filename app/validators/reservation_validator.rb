# frozen_string_literal: true

class ReservationValidator < Dry::Validation::Contract
  params do
    required(:hotel_name).filled(:string)
    required(:price).value(:integer)
    required(:currency).value(:string)
    required(:entry_date).value(:date_time)
    required(:departure_date).value(:date_time)
    required(:guest_name).filled(:string)
    required(:guest_email).filled(:string)
  end

  rule(:price) do
    key.failure("Must be positive") unless values[:price].positive?
  end

  rule(:guest_email) do
    key.failure("Invalid email") unless URI::MailTo::EMAIL_REGEXP.match?(values[:guest_email])
  end

  rule(:departure_date) do
    if values[:departure_date] <= values[:entry_date]
      key.failure("Must be greater than entry date")
    end
  end
end
