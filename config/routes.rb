Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }

  devise_scope :user do
    get '/signup', to: 'users/registrations#new'
    post '/signup',  to: 'users/registrations#create'
    get '/account', to: 'users/registrations#detail'
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
