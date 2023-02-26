# frozen_string_literal: true

module Resultable
  class Result
    attr_reader :result, :errors

    def initialize(result: nil, errors: [])
      @result = result
      @errors = errors
    end

    def success?
      @errors.empty?
    end
  end

  [:list_all, :find_by_id, :create, :update, :delete].each do |method|
    define_method(method) do |*args, &block|
      as_result { super(*args, &block) }
    end
  end

  private

  def as_result
    Result.new(result: yield)
  rescue StandardError => e
    Result.new(errors: [e.message])
  end
end
