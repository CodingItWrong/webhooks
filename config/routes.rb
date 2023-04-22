Rails.application.routes.draw do
  namespace :riverbed do
    resources :links, only: %w[update]
  end
end
