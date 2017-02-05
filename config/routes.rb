require 'sidekiq/web'

Rails.application.routes.draw do
  resources :user_roles
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  resources :roles
  resources :milestones
  resources :user_skills
  resources :skills
  resources :onboarding

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

  root to: "pages#index"
end
