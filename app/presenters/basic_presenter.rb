# frozen_string_literal: true

class BasicPresenter
  def initialize(object)
    @object = object
  end

  class << self
    def present(object)
      case object
      when Enumerable
        object.map { |item| new(item) }
      else
        new(object)
      end
    end
  end
end
