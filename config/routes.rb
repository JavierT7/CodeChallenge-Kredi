# frozen_string_literal: true

Rails.application.routes.draw do
  resources :invoices
  root 'home#index', as: :home_index

  devise_for :users

  resources :users

  get 'my_invoices' => 'invoices#my_invoices', as: :my_invoices
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
