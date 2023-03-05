# frozen_string_literal: true

class ReservationsService
  prepend Resultable

  def initialize(repo: nil, validator: nil)
    @repo = repo || Mongodb::ReservationsRepo.new
    @validator = validator || ReservationValidator.new
  end

  def list_all
    repo.all
  end

  def find_by_id(id)
    repo.find(id)
  end

  def create(attributes)
    validate!(attributes)

    repo.create(attributes)
  end

  def update(id, attributes)
    validate!(attributes)

    reservation = repo.find(id)
    repo.update(reservation, attributes)
  end

  def delete(id)
    reservation = repo.find(id)
    repo.delete(reservation)
  end

  private

  attr_reader :repo, :validator

  def validate!(attributes)
    validation = validator.call(attributes)

    return if validation.success?

    raise ArgumentError, validation.errors(full: true).to_h.values.join(", ")
  end
end
