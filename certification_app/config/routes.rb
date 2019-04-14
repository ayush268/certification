Rails.application.routes.draw do

  root    'static_pages#home'
  get     '/help',                      to: 'static_pages#help'
  get     '/about',                     to: 'static_pages#about'
  get     '/contact',                   to: 'static_pages#contact'

  get     '/signup',                    to: 'users#new'
  get     '/users/:public_addr',        to: 'users#show',                 as: 'user'
  get     '/users/edit/:public_addr',   to: 'users#show',                 as: 'edit'
  get     '/login',                     to: 'sessions#new'

  get     '/courses',                   to: 'courses#all'
  get     '/courses/add_course',        to: 'courses#new',                as: 'add_course'
  get     '/courses/:id',               to: 'courses#show',               as: 'course'

  get     '/admin/:hashed_id',          to: 'admin#all',                  as: 'admin'

  post    '/login',                     to: 'sessions#create'
  post    '/signup',                    to: 'users#create'

  post    '/courses/add_course',        to: 'courses#create'

  post    '/admin/:hashed_id',          to: 'admin#submit',               as: 'admin_post'

  delete  '/logout',                    to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
