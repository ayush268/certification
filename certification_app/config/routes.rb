Rails.application.routes.draw do
  get 'sessions/new'
  get     'users/show'
  get     'users/new'
  root    'static_pages#home'
  get     '/help',            to: 'static_pages#help'
  get     '/about',           to: 'static_pages#about'
  get     '/contact',         to: 'static_pages#contact'
  get     '/signup',          to: 'users#new'
  get     '/login',           to: 'sessions#new'
  post    '/login',           to: 'sessions#create'
  post    '/signup',          to: 'users#create'
  delete  '/logout',          to: 'sessions#destroy'
  resources :users,         param: :public_addr
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
