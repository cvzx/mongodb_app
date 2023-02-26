# frozen_string_literal: true

class BasicPresenter
  def initialize(object)
    @object = object
  end

  def self.present(object)
    case object
    when Enumerable
      object.map { |item| new(item) }
    else
      new(object)
    end
  end
end


