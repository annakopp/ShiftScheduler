ShiftScheduler::Application.routes.draw do

  root to: "shifts#index"

  resources :users, :only => [:create, :new, :index, :show, :edit, :update] do

    post "create_employee", on: :member

    put 'update_confirmed', on: :member
    get 'confirm', to: 'users#confirm_user'
  end

  get "list_employees", to: "users#list_employees"
  get "add_employee", to: "users#add_employee"

  resource :session, :only => [:create, :destroy, :new]

  resources :shifts, only: [:create, :destroy, :index, :show] do
    resource :shift_request, only: [:create, :destroy]
    resources :shift_requests, only: [:index, :update]
  end

  resources :shift_requests, only: [:create, :index, :update, :destroy]

end
