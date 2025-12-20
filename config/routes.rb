Rails.application.routes.draw do
  get '/:list_name/', to: 'messages#index', as: :list
  resources :list, only: [], path: '', param: :name do
    resources :messages, only: :show, path: '', param: :list_seq
  end
  get '/attachments/:encoded_key/*filename' => 'attachments#show', as: :attachment

  get '/messages/search_all', to: 'messages#search_all', as: :search_all_messages

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'messages#index'
end
