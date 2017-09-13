Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/',           to: 'session#home'
  get '/login',      to: 'session#login'
  get '/authorized', to: 'session#authorized'
  get '/logout',     to: 'session#logout'

  root to: 'session#home'
end
