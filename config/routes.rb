Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :categories do
        resources :ideas, only: [:index, :create]
      end
    end
  end
end
