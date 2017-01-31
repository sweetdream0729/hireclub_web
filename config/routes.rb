Rails.application.routes.draw do

  get "/about",   to: "pages#about",   as: :about
  get "/contact", to: "pages#contact", as: :contact

  devise_for :users,
    path:        '',
    path_names:  {:sign_in => 'login', :sign_out => 'logout', :edit => 'settings', :sign_up => "signup"},
    controllers: {registrations: 'registrations',
                  omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: "pages#index"
end
