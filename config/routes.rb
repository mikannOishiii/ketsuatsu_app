Rails.application.routes.draw do
  namespace :admins do
    resources :posts, only: [:index, :new, :edit, :create, :update, :destroy]
    get '/dashboard', to: 'static_pages#dashboard'
  end
  devise_for :admins, :controllers => {
    sessions: 'admins/sessions',
  }
  root 'static_pages#home'
  devise_for :users, :controllers => {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords',
  }

  devise_scope :user do
    get '/signup', to: 'users/registrations#new'
    post '/signup',  to: 'users/registrations#create'
    get '/signup-with-sns', to: 'users/registrations#sns'
    get '/account/profile-edit', to: 'users/registrations#edit'
    get '/account/password-edit', to: 'users/registrations#password'
    post '/account/update', to: 'users/registrations#update'
    get '/account/setting', to: 'users/registrations#setting'
    get '/account/leave', to: 'users/registrations#leave'
    get '/login', to: 'users/sessions#new'
    post '/login', to: 'users/sessions#create'
    get '/logout', to: 'users/sessions#destroy'
    get '/passwords/new', to: 'users/passwords#new'
    get '/passwords/edit', to: 'users/passwords#edit'
  end
  resources :records, only: [:new, :create, :edit, :update, :destroy] do
    collection do
      get 'search'
      post 'date_range'
    end
  end
  get '/terms', to: 'static_pages#terms'
  get '/export', to: 'static_pages#export'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
