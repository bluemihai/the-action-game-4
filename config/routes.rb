Rails.application.routes.draw do
  namespace :admin do
    get 'debug'
  end


  namespace :api do
    namespace :v1 do
      resources :players do
        resources :aktions, only: [:index, :show]
      end
    end
  end

  resources :friendships
  resources :accepted_challenges
  resources :challenges
  resources :interruptions
  resources :insights
  resources :aktions do
    collection { get :continue, :start, :test, :current }
  end
  resources :role_assignments
  resources :project_memberships
  resources :team_memberships do
    member { get :update_from_api }
  end
  resources :locations, :verbs
  resources :players do
    resources :aktions
  end
  resources :teams do
    member { get :join, :leave }
    resources :projects
    resources :roles
  end

  resources :roles
  resources :projects

  root to: 'visitors#welcome'
  get '/contact' => 'visitors#contact'
  get '/welcome' => 'visitors#welcome'
  get '/help' => 'visitors#help'
  get '/chat' => 'visitors#chat'
  get '/sounds' => 'visitors#sounds'
  get '/scores' => 'visitors#scores'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
