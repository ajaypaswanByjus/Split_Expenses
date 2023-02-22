Rails.application.routes.draw do
  get 'activities/index'
  resources :expenses
  resources :groups
  resources :home, only: [:index]
  resources :activities
  devise_for :users #, :controllers => { registrations: 'registrations'}
  get 'home/main'
  get 'home/external'
  get 'home/friends'

  get 'search', to: 'groups#search'

  # resources :groups do
  #   resources :splits, only: [:new, :create]
  # end
  post '/groups/:id/split', to: 'groups#split_group_expenses', as: 'split_group_expenses'

  get 'groups/:id/equal_split', to: 'groups#equal_split', as: 'group_equal_split'


  resources :groups do
    get 'equal_split', on: :member
  end
  resources :group do 
    resources :comments, only: [:create]
  end
  
  
  root "home#index"
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
end
