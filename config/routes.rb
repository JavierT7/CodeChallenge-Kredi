# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index', as: :home_index

  devise_for :users

  resources :users

  get 'received_invoices/:id' => 'invoices#received_invoices', as: :received_invoices
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
