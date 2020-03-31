Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
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
  end
  resources :records, only: [:new, :create, :update, :destroy] do
    collection do
      get 'search'
      post 'date_range'
    end
  end
  get '/terms', to: 'static_pages#terms'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
