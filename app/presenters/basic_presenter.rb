# frozen_string_literal: true

class BasicPresenter
  def initialize(object)
    @object = object
  end

  def self.present(item)
    new(item)
  end

  def self.present_collection(collection)
    collection.map { |item| present(item) }
  end
end


