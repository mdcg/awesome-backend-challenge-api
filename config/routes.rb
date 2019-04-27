Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :orders
      resources :batches do
        put('produce' => 'batches#produce')
        # put('send' => 'batches#send')
      end
      get('search' => 'search#search')
    end
  end
end
