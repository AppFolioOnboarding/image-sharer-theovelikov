Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'images#index'
  resources :images, only: %i[show new create index]
  get '/tagged', to: 'images#tagged', as: :tagged
end
