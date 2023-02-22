# frozen_string_literal: true

class ReservationsService
  class Result
    attr_accessor :result, :errors

    def initialize(result: nil, errors: [])
      @result = result
      @errors = errors
    end

    def success?
      errors.empty?
    end
  end

  def initialize(repo = nil)
    @repo = repo
  end

  def list_all
    as_result { repo.all }
  end

  def create(attributes)
    as_result { repo.create(attributes) }
  end

  def update(id, attributes)
    as_result do
      reservation = repo.find(id)
      repo.update(reservation, attributes)
    end
  end

  def delete(id)
    as_result do
      reservation = repo.find(id)
      repo.delete(reservation)
    end
  end

  private

  attr_reader :repo

  def as_result
    Result.new(result: yield)
  rescue StandardError => e
    Result.new(errors: [e.message])
  end
end
