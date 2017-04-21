Rails.application.routes.draw do
  namespace :api do
    # 1screen - 1request API
    namespace :v1 do
      # ...
    end

    # RESTful API
    namespace :v2 do
      resources :companies, only: [:index, :show]
    end
  end
end
