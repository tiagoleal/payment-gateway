Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /en|pt/ do
    get "/signup", to: "users#new"
    get "dashboard", to: "pages#dashboard"
    get "billing_reports/index"

    resources :users, only: [ :new, :create ]
    resource :session, only: [ :new, :create, :destroy ]
    resources :passwords, param: :token
    resources :clients

    root "pages#home"
  end
end
