Rails.application.routes.draw do
  resources :experiments, only: [:index]
end
