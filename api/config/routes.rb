Rails.application.routes.draw do
  get  'sessions/current_user' => 'sessions#show'
  post 'login' => 'sessions#create'

  resources :users, only: [ :create, :show, :update ]

  resources :wallet_transactions, path: :transactions, only: [:index, :show] do
    collection do
      post :deposit
      post :withdrawal
      post :transfer
    end
    member do
      patch :confirm
    end
  end
end
