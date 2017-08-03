require 'sidekiq/web'

Rails.application.routes.draw do
  post 'webhooks/sparkpost' => 'webhooks#sparkpost'
  post 'webhooks/acuity_scheduled' => 'webhooks#acuity_scheduled'
  post 'webhooks/acuity_rescheduled' => 'webhooks#acuity_rescheduled'
  post 'webhooks/acuity_canceled' => 'webhooks#acuity_canceled'

  get 'settings' => 'settings#index', as: :settings
  get 'settings/status'
  get 'settings/account'
  get 'settings/links'
  get 'settings/notifications'
  get 'settings/payments'
  put 'settings/update'

  mount ActionCable.server => '/cable'

  get '/sitemap.xml', to: redirect("https://s3-us-west-1.amazonaws.com/hireclub-production/sitemaps/sitemap.xml.gz", status: 301)
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount StripeEvent::Engine, at: '/stripe/webhook' 

  get 'dashboard' => 'dashboard#index', as: :dashboard
  get 'dashboard/yesterday' => 'dashboard#yesterday'
  get 'dashboard/this_week' => 'dashboard#this_week'
  get 'dashboard/last_week' => 'dashboard#last_week'
  get 'dashboard/this_month' => 'dashboard#this_month'
  get 'dashboard/last_month' => 'dashboard#last_month'
  get 'dashboard/all' => 'dashboard#all'

  get 'heroes' => 'heroes#index', as: :heroes

  get 'notifications' => 'notifications#index', as: :notifications
  get 'search' => 'search#index', as: :search
  get 'search/jobs' => 'search#jobs'
  get 'search/projects' => 'search#projects'
  get 'search/members' => 'search#members'
  get 'search/companies' => 'search#companies'
  get 'search/skills' => 'search#skills'
  get 'search/communities' => 'search#communities'

  get 'feed', to: "feed#index", as: :feed

  resources :appointment_reviews, except: [:index, :update, :edit, :destroy]
  resources :appointment_messages, only: [:create, :destroy, :edit, :update] do
    member do
      get :cancel_edit
    end
  end
  resources :appointments, only: [:index, :show] do
    collection do
      get :search
      get :completed
      get :canceled
      get :upcoming
      get :assigned
      get :unassigned
      get :all
    end
    member do
      get :refresh
      get :complete
    end

    resources :attachments, module: :appointments
  end

  resources :assignees, only: [:create, :destroy] 
  resources :subscriptions, only: [:new, :create, :show] 
  get 'subscription/cancel' => 'subscriptions#cancel_subscription'
  post 'subscription/cancel' => 'subscriptions#cancel', as: :cancel_subscription

  
  resources :job_referrals, only: [:show]
  resources :community_invites, except: [:edit, :update]
  
  resources :communities do
    member do
      get :join
      get :leave
      get :members
    end
  end

  resources :posts do
    resources :comments, module: :posts
  end

  resources :invites, except: [:edit, :update]

  resources :stories do
    collection do
      get :drafts
    end
    member do
      get :publish
    end
    resources :comments, module: :stories
  end

  resources :jobs do
    resources :comments, module: :jobs
    member do
      get :suggest_skill
      get :refer
      get :referral_viewed
      get :refresh_job_scores
    end
  end

  resources :review_requests do
    resources :comments, module: :review_requests
  end

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

  resources :companies, :constraints => { :id => /[\w\.\-]+/ }, :format => false do
    member do
      get :refresh
      get :follow
      get :unfollow
    end
  end

  resources :user_roles
  resources :roles

  resources :attachments, only: [:destroy]

  resources :comments, only: [:destroy] do
    member do
      get :like
      get :unlike
    end
  end

  resources :milestones do
    resources :comments, module: :milestones
  end

  resources :projects do
    resources :comments, module: :projects
  end

  resources :user_skills
  get 'skills/available' => 'skills#available'
  resources :skills
  resources :onboarding

  get "/locations",     to: "locations#index",   as: :locations
  get "/headshots",     to: "pages#headshots",   as: :headshots
  get "/styles",        to: "pages#styles",      as: :styles
  get "/privacy",       to: "pages#privacy",     as: :privacy
  get "/about",         to: "pages#about",       as: :about
  get "/contact",       to: "pages#contact",     as: :contact

  get 'users/username' => 'users#username'
  devise_for :users,
    path:        '',
    path_names:  {:sign_in => 'login', :sign_out => 'logout', :sign_up => "signup"},
    controllers: {registrations: 'registrations',
                  omniauth_callbacks: 'users/omniauth_callbacks' }

  get "/members",   to: "users#index",   as: :members

  resources :users, :only => [:show, :update], :path => '/', :constraints => { :id => /[\w\.\-]+/ }, :format => false do
    member do
      get :print
      get :follow
      get :unfollow
      get :followers
      get :following
      get :resend_confirmation
    end
  end

  authenticated :user do
    root :to => 'feed#index', as: :authenticated_root
  end

  root to: "pages#index"
end
