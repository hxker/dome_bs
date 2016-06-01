Rails.application.routes.draw do

  root to: 'home#index'
  devise_for :users, path: 'account', controllers: {
      sessions: 'users/sessions', registrations: 'users/registrations',
      confirmations: 'users/confirmations',
      passwords: 'users/passwords'
  }
  mount RuCaptcha::Engine => '/rucaptcha'
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

  get 'user' => redirect('/user/preview')

  match 'user/preview' => 'user#preview', as: 'user_preview', via: [:get, :post]
  match 'user/profile' => 'user#profile', as: 'user_profile', via: [:get, :post]
  match 'user/update_avatar' => 'user#update_avatar', as: 'user_update_avatar', via: [:post]
  match 'user/remove_avatar' => 'user#remove_avatar', as: 'user_remove_avatar', via: [:post]
  match 'user/passwd' => 'user#passwd', as: 'user_passwd', via: [:get, :post]
  match 'user/reset_mobile' => 'user#reset_mobile', as: 'user_reset_mobile', via: [:get, :post]
  match 'user/reset_email' => 'user#reset_email', as: 'user_reset_email', via: [:get, :post]
  match 'user/send_email_code' => 'user#send_email_code', as: 'user_send_email_code', via: [:post]
  match 'user/send_add_mobile_code' => 'user#send_add_mobile_code', as: 'user_send_add_mobile_code', via: [:post]
  match 'user/comp' => 'user#comp', as: 'user_comp', via: [:get]
  match 'user/consult' => 'user#consult', as: 'user_consult', via: [:get, :post]
  match 'user/point' => 'user#point', as: 'user_point', via: [:get, :post]
  match 'user/add_point' => 'user#add_point', as: 'user_add_point', via: [:get, :post]
  match 'user/notification' => 'user#notification', as: 'user_notification', via: [:get]
  get '/user/notify' => 'user#notify_show'
  match '/user/add_school' => 'user#add_school', as: 'user_add_school', via: [:post]


  # mount ActionCable.server => '/cable'
end
