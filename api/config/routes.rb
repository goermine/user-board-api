Rails.application.routes.draw do
  get  'sessions/current_user' => 'sessions#show'
  post 'login'        => 'sessions#create'

  resources :users, only: [ :create, :show, :update ]
end
