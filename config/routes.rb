require "sidekiq/web"
require "sidekiq/cron/web"
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    defaults format: :json do
      resources :shows, only: [:index] do
        member do
          post :book_tickets
        end
      end
    end
  end
end
