Rails.application.routes.draw do
  resources :experiments, only: [:index]

  namespace :admin do
    resource :statistics, only: [:show]
  end
end
