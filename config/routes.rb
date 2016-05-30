Rails.application.routes.draw do

  root to: 'home#index'
  devise_for :users, path: 'account', controllers: {sessions: 'users/sessions', registrations: 'users/registrations', confirmations: 'users/confirmations'}
  resources :accounts, only: [:new, :create, :destroy] do
    collection do
      get :register
      post :register_post
      post :validate_captcha
      get :forget_password
      get :reset_password
      post :reset_password_post
      post :send_code
      post :register_email_exists
      post :register_mobile_exists
      post :register_nickname_exists
    end
  end
  mount RuCaptcha::Engine => '/rucaptcha'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
