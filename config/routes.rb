Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root :to => 'unused#unused'

  scope defaults: {format: :json} do


    post 'logins', controller: :logins, action: :login
    get 'logins/token', controller: :logins, action: :token
    delete 'logins/:id', controller: :logins, action: :logout

    resources :users, only: [:create, :index]
    get 'users/verify', controller: :users, action: :verify
    post 'users/resend_link', controller: :users, action: :resend_link
    post 'users/reset_password', controller: :users, action: :reset_password
    put 'users/change_password', controller: :users, action: :change_password

    resources :edos, only: [:index,:show]
    get 'edos/:id/members', controller: :edos, action: :members

    resources :organizations, only: [:show]

    resources :projects, only: [:show]

    resources :forms, only: [:index, :show]
    put 'forms/notification_form', controller: :forms, action: :notification_form

    resources :attachments, only: [:create, :destroy, :show]

    resources :comms, only: [:index, :create, :update, :show, :destroy]
    post 'comms/notify_members', controller: :comms, action: :notify_members

    resources :notifications, only: [:index, :create, :update, :show, :destroy]

    resources :leads, only: [:index, :create]

    resources :restrictions, only: [:index]

  end
end