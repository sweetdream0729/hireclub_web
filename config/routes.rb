Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get "/about",   to: "pages#about",   as: :about
  get "/contact", to: "pages#contact", as: :contact

  devise_for :users,
    path:        '',
    path_names:  {:sign_in => 'login', :sign_out => 'logout', :edit => 'settings', :sign_up => "signup"},
    controllers: {registrations: 'registrations',
                  omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, :only => [:show, :update], :path => '/', :constraints => { :id => /[\w\.\-]+/ }, :format => false do
    member do
    end
  end

  root to: "pages#index"
end
