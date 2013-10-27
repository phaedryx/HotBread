HotBread::Application.routes.draw do
  root "welcome#index"
  get "dashboard/index", to: "dashboard#index", as: :dashboard

  match "/auth/:provider/callback", to: "sessions#create",  via: :all
  get "sign_out",                   to: "sessions#destroy", as: :sign_out
  get "/auth/failure",              to: "sessions#failure"

  resources :users, only: [:edit, :update] # allow users to edit their profile
end
