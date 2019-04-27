Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :orders
      resources :batches do
        put 'produce', to: 'batches#produce'
        put 'submit', to: 'batches#submit'
      end
      get 'search', to: 'search#search'
      get 'report', to: 'report#index'
    end
  end
end
