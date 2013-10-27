HotBread::Application.routes.draw do
  root "welcome#index"
  get "dashboard/index"

  match "/auth/:provider/callback", to: "sessions#create",  via: :all
  get "sign_out",                   to: "sessions#destroy", as: :sign_out
  get "/auth/failure",              to: "sessions#failure"
end
