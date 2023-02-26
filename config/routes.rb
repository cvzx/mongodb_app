# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'reservations/new', to: 'reservations#new', as: 'new_reservation'
  get 'reservations/:id/edit', to: 'reservations#edit', as: 'edit_reservation'
  resources :reservations

  scope :api, defaults: { format: :json } do
    resources :reservations
  end

end
