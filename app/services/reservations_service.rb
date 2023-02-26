# frozen_string_literal: true

class ReservationsService
  prepend Resultable

  def initialize(repo: MongodbReservationRepository.new, validator: ReservationValidator.new)
    @repo = repo
    @validator = validator
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

    raise ArgumentError, validation.errors.join(", ") unless validation.success?
  end
end
