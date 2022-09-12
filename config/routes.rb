# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'invoices#index', as: :invoice_index

  devise_for :users

  resources :users
  resources :invoices

  get 'my_invoices' => 'invoices#my_invoices', as: :my_invoices
  post 'upload_zip_file' => 'invoices#upload_zip_file', as: :upload_zip_file
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
