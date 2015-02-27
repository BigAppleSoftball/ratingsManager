Rails.application.routes.draw do
  root 'welcome#login'

  resources :games
  resources :fields
  resources :committees
  resources :board_members
  resources :hallof_famers
  resources :admins
  #resources :ratings
  #resources :rosters
  resources :profiles
  resources :teams_sponsors, :only => [:index, :show]
  resources :sponsors
  resources :seasons, :only => [:index, :show]
  resources :divisions, :only => [:index, :show]
  resources :teams, :only => [:index, :show]
  resources :sessions, only: [:new, :create, :destroy]

  # sessions
  match '/signup',  to: 'profiles#new',            via: 'get'
  #match '/help',    to: 'static_pages#help',    via: 'get'
  #match '/about',   to: 'static_pages#about',   via: 'get'
  #match '/contact', to: 'static_pages#contact', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  get '/signout', to: 'sessions#destroy',     via: 'delete'

  get '/welcome', to: 'welcome#index'
  #teamsnap api login
  get '/login', to: 'welcome#login'
  get '/teamsnaplogout', to: 'welcome#logout'
  get '/teamssnap/:teamId/:rosterId', to: 'welcome#team', as: 'rosterId'
  get '/ranking/:teamId/:rosterId/:playerId', to: 'welcome#ranking', as: 'playerId'
  post '/teamsnaplogin', to: 'welcome#teamsnaplogin'

  # website iframes
  get '/showallsponsors', to: 'sponsors#all_sponsors'
  get '/sponsorscarousel', to: 'sponsors#sponsor_carousel'
  get '/showallhof', to: 'hallof_famers#all_hof'
  get '/showallboard', to: 'board_members#all_board'
  get '/showallcommittee', to: 'committees#all_committee'
  get '/showfields', to: 'fields#show_map'
  get '/loadsidebar', to: 'welcome#basl_sidebar'
  get '/loadcalendar', to: 'welcome#load_calendar'
  get '/getleaguesponsors', to: 'sponsors#league_sponsors'

  #helpers
  post '/fields/set_all', to: 'fields#set_all'

  #admin panel
  get '/admin/home', to: 'admins#home'

  #errors
  get '/403', to: 'welcome#error403'

end
