# frozen_string_literal: true

Rails.application.routes.draw do
  get "reservations/new", to: "reservations#new", as: "new_reservation"
  get "reservations/:id/edit", to: "reservations#edit", as: "edit_reservation"
  resources :reservations

  scope :api, defaults: { format: :json } do
    resources :reservations
  end
end
