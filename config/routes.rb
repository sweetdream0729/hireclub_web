require 'sidekiq/web'

Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  get 'search' => 'search#index', as: :search
  get 'feed', to: "feed#index", as: :feed

  resources :company_imports, only: [:new, :create] do
    collection do
      get "search"
    end
  end

  resources :companies do
    member do
      get :refresh
    end
  end
  
  resources :user_roles
  resources :roles
  resources :milestones
  resources :user_skills
  resources :skills
  resources :onboarding

  get "/locations",   to: "locations#index",   as: :locations
  get "/privacy",   to: "pages#privacy",   as: :privacy
  get "/about",   to: "pages#about",   as: :about
  get "/contact", to: "pages#contact", as: :contact

  devise_for :users,
    path:        '',
    path_names:  {:sign_in => 'login', :sign_out => 'logout', :edit => 'settings', :sign_up => "signup"},
    controllers: {registrations: 'registrations',
                  omniauth_callbacks: 'users/omniauth_callbacks' }

  get "/members",   to: "users#index",   as: :members

  resources :users, :only => [:show, :update], :path => '/', :constraints => { :id => /[\w\.\-]+/ }, :format => false do
    resources :projects
    member do
      
    end
  end

  authenticated :user do
    root :to => 'feed#index', as: :authenticated_root
  end
  root to: "pages#index"
end
