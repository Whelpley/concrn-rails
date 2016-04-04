Streetmom::Application.routes.draw do

  devise_for :users, path_prefix: 'my'

  resources :reports, except: %w(edit) do
    collection do
      get 'active'
      get 'history'
    end

    member do
      post 'upload' => 'reports#update'
      get 'download' => 'reports#download', :as => :download
    end
  end

  resources :users, except: %w(destroy) do
    collection do
      get 'by_phone'
      get 'deactivated'
    end
    member do
      post 'start', to: 'shifts#start', :as => :start_shift
      post  'end',  to: 'shifts#end',   :as => :end_shift
    end
  end

  resources :phone_numbers, only: [:new, :create]
  post 'phone_numbers/verify' => "phone_numbers#verify"

  resources :clients, except: %w(destroy) do
    collection do
      get 'deactivated'
    end
  end

  resources :dispatches, only: %w(create update)
  resources :logs,       only: %w(create update)
  resources :reporters,  only: %w(show create new)
  resources :sms,        only: %w(create)

  resources :reporter_locations, only: %w(create)

  resources :uploads,    only: %w(destroy)

  root 'pages#home'

  resources :timeline_map do
    collection do
      get 'timeline_map' => 'timeline_map#index'
    end
  end

  get '/visualizations/reports_timeline_map', to: 'visualizations#reports_timeline_map'

  get '/visualizations/reports_charts', to: 'visualizations#reports_charts'
end
