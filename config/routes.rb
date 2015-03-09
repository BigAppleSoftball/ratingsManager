Rails.application.routes.draw do
  root 'static_pages#home'

  resources :games
  resources :fields
  resources :committees
  resources :board_members
  resources :hallof_famers
  resources :admins
  resources :rosters, :only => [:destroy]
  #resources :ratings
  resources :teams
  resources :profiles
  resources :teams_sponsors, :only => [:index, :show]
  resources :sponsors
  resources :seasons, :only => [:index, :show]
  resources :divisions, :only => [:index, :show, :edit]
  resources :teams, :only => [:index, :show]
  resources :sessions, only: [:new, :create, :destroy]

  # games
  get '/games/:id/:teamid', to: 'games#game_attendance'
  post '/set_attendance', to: 'game_attendances#set_attendance'

  get '/home', to:'static_pages#home'

  # seasons 
  get '/get_divisions_by_season', to:'seasons#get_divisions_by_season'

  # sessions
  match '/signup',  to: 'profiles#new', via: 'get'
  match '/signin',  to: 'sessions#new', via: 'get'
  get '/signout', to: 'sessions#destroy', via: 'delete'
  get '/teams_by_season', to: 'teams#get_teams_by_season'

  post '/add_player_to_roster', to: 'rosters#add_player_to_roster'

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

  mount UserImpersonate::Engine => "/impersonate", as: "impersonate_engine"

  #errors
  get '/403', to: 'welcome#error403'

end
