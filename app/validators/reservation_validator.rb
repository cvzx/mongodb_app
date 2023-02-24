# frozen_string_literal: true

class ReservationValidator < Dry::Validation::Contract
  params do
    required(:hotel_name).value(:string)
    required(:price).value(:integer)
    required(:currency).value(:string)
    required(:entry_date).value(:date_time)
    required(:departure_date).value(:date_time)
    required(:guest_name).value(:string)
    required(:guest_email).value(:string)
  end

  rule(:price) do
    key.failure('Must be positive') unless values[:price].positive?
  end

  rule(:guest_email) do
    key.failure('Invalid email') unless URI::MailTo::EMAIL_REGEXP.match?(values[:guest_email])
  end

  rule(:departure_date) do
    unless values[:departure_date] > values[:entry_date]
      key.failure('Must be greater than entry date')
    end
  end
end
