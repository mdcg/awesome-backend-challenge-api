Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :orders
      resources :batches
      get('search' => 'search#search')
    end
  end
end
