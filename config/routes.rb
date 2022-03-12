Rails.application.routes.draw do
  # scope :api, defaults: { format: :json } do
  #   devise_for :users
  # end
  
  namespace :api, defaults: { format: :json } do
    resources :sessions, only: [:create] 
    resources :registrations, only: [:create] 
    resources :categories
    scope "categories/:category_id" do
      resources :tasks
    end
  end
end
