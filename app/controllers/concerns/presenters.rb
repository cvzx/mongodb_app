# frozen_string_literal: true

module Presenters
  extend ActiveSupport::Concern

  private

  def present_collection(collection)
    collection.map { |item| present(item) }
  end

  def present(item)
    presenter.new(item)
  end

  def presenter
    raise NotImplemented
  end
end
