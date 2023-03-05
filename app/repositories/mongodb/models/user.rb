# frozen_string_literal: true

module Mongodb
  module Models
    class User
      include Mongoid::Document

      field :name, type: String
      field :email, type: String

      embedded_in :reservation
    end
  end
end
