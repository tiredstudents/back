# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/auth', to: 'session#create'

      resources :users
      resources :projects do
        resources :vacancies
      end
    end
  end
end
