Rails.application.routes.draw do

  root    'static_pages#home'
  get     '/help',                      to: 'static_pages#help'
  get     '/about',                     to: 'static_pages#about'
  get     '/contact',                   to: 'static_pages#contact'

  get     '/signup',                    to: 'users#new'
  get     '/users/:public_addr',        to: 'users#show',                 as: 'user'
  get     '/users/edit/:public_addr',   to: 'users#edit',                 as: 'edit'
  get     '/login',                     to: 'sessions#new'

  get     '/courses',                   to: 'courses#all'
  get     '/courses/add_course',        to: 'courses#new',                as: 'add_course'
  get     '/courses/:id',               to: 'courses#show',               as: 'course'

  get     '/admin/:hashed_id',          to: 'admin#all',                  as: 'admin'

  get     '/verify',                    to: 'verify#get'

  post    '/login',                     to: 'sessions#create'
  post    '/signup',                    to: 'users#create'

  post    '/users/edit/:public_addr',   to: 'users#update',               as: 'update'

  post    '/courses/add_course',        to: 'courses#create'
  post    '/courses/:id',               to: 'courses#update'

  post    '/admin/:hashed_id',          to: 'admin#submit',               as: 'admin_post'

  post    '/verify',                    to: 'verify#post'

  delete  '/logout',                    to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
