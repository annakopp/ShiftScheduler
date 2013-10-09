ShiftScheduler::Application.routes.draw do

  root to: "users#index"

  resources :users, :only => [:create, :new, :index, :show, :edit, :update] do

    post "create_employee", on: :member

    put 'update_confirmed', on: :member
    get 'confirm', to: 'users#confirm_user'
  end

  get "list_employees", to: "users#list_employees"
  get "add_employee", to: "users#add_employee"

  resource :session, :only => [:create, :destroy, :new]

  resources :shifts, only: [:create, :new, :destroy, :index]

  resources :shift_requests, only: [:create, :index, :update, :destroy]


end
