require 'sidekiq/web'

Rails.application.routes.draw do
  get '/sitemap.xml', to: redirect("https://s3-us-west-1.amazonaws.com/hireclub-production/sitemaps/sitemap.xml.gz", status: 301)
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  get 'notifications' => 'notifications#index', as: :notifications
  get 'search' => 'search#index', as: :search
  get 'feed', to: "feed#index", as: :feed

  resources :review_requests
  resources :messages, only: [:create]

  resources :conversations do
    collection do
      get :between
    end
  end
  
  resources :resumes, except: [:edit, :update]
  resources :likes, only: [:index, :new, :create, :destroy]

  resources :badges
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
  
  resources :milestones do
    resources :comments, module: :milestones
  end

  resources :projects do
    resources :comments, module: :projects
  end

  resources :user_skills
  resources :skills
  resources :onboarding

  get "/locations",   to: "locations#index",   as: :locations
  get "/privacy",   to: "pages#privacy",   as: :privacy
  get "/about",   to: "pages#about",   as: :about
  get "/contact", to: "pages#contact", as: :contact

  get 'users/username' => 'users#username'
  devise_for :users,
    path:        '',
    path_names:  {:sign_in => 'login', :sign_out => 'logout', :edit => 'settings', :sign_up => "signup"},
    controllers: {registrations: 'registrations',
                  omniauth_callbacks: 'users/omniauth_callbacks' }

  get "/members",   to: "users#index",   as: :members

  resources :users, :only => [:show, :update], :path => '/', :constraints => { :id => /[\w\.\-]+/ }, :format => false do
    
    member do
      get :print
    end
  end

  authenticated :user do
    root :to => 'feed#index', as: :authenticated_root
  end

  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'
  
  root to: "pages#index"
end
