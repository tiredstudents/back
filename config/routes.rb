# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/auth', to: 'session#create'

      resources :users, except: [:delete] do
        patch '/fire', on: :member, to: 'users#fire'
        get '/projects', on: :member, to: 'users#projects'
        get '/owned_projects', on: :member, to: 'users#owned_projects'
        get '/managed_projects', on: :member, to: 'users#managed_projects'
        get '/managed_vacancies', on: :member, to: 'users#managed_vacancies'
      end
      resources :projects, except: [:delete] do
        get '/resources', on: :member, to: 'projects#resources'
        patch '/free_resource', on: :member, to: 'projects#free_resource'
        patch '/finish', on: :member, to: 'projects#finish'
        resources :vacancies, shallow: true, except: [:delete] do
          patch '/close', on: :member, to: 'vacancies#close'
          patch '/assign_for_hr', on: :member, to: 'vacancies#assign_for_hr'
          patch '/unassign', on: :member, to: 'vacancies#unassign'
          patch '/complete', on: :member, to: 'vacancies#complete'
          resources :candidates, shallow: true do
            get '/vacancies', on: :member, to: 'candidates#vacancies'
          end
        end
      end
      resource :skills do
        get '/all', to: 'skills#all'
      end
      resource :grades do
        get '/all', to: 'grades#all'
      end
    end
  end
end
