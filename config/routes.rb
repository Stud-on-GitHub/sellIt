Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  get 'ping' => 'table_test#ping'

  # resources :classifieds, only: [:show, :index, :create, :update, :destroy]
  resources :classifieds, only: [:show, :index, :create, :update, :destroy] do #add annex operation
    member do
      post 'publications' => 'classifieds#publish'
    end
  end
  resources :users, only: [:show]
end
