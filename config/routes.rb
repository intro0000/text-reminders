Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#index'

  get 'home' => 'home#index'

  post 'twilio/voice' => 'twilio#voice'
  post 'notifications/notify' => 'notifications#notify'
  post 'twilio/status' => 'twilio#status'

  resources :contacts
  # Defines the root path route ("/")
  # root "articles#index"
end
