Rails.application.routes.draw do

  root 'static_pages#home'
  resources :offers

  resources :games
  resources :parks
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
  resources :seasons
  resources :divisions
  resources :teams, :only => [:index, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :teamsnap_payments

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
  get '/teamsnap/login', to: 'teamsnap#login'
  post '/teamsnap/login', to: 'teamsnap#teamsnaplogin'
  get '/teamsnap/logout', to: 'teamsnap#logout'
  get 'teamsnap/index', to:'teamsnap#index'
  get '/teamssnap/:teamId/:rosterId', to: 'teamsnap#team', as: 'rosterId'
  get '/ranking/:teamId/:rosterId/:playerId', to: 'teamsnap#ranking', as: 'playerId'
  get '/teamsnap', to:'teamsnap#redirect'
  get '/teamsnap/updateplayer', to:'payments_tracker#update_teamsnap_player'


  # website iframes
  get '/showallsponsors', to: 'sponsors#all_sponsors'
  get '/sponsorscarousel', to: 'sponsors#sponsor_carousel'
  get '/showallhof', to: 'hallof_famers#all_hof'
  get '/showallboard', to: 'board_members#all_board'
  get '/showallcommittee', to: 'committees#all_committee'
  get '/showfields', to: 'parks#show_map'
  get '/showparks', to: 'parks#show_map'
  get '/loadsidebar', to: 'welcome#basl_sidebar'
  get '/loadcalendar', to: 'welcome#load_calendar'
  get '/getleaguesponsors', to: 'sponsors#league_sponsors'

  # parks
  post '/parks/set_all', to: 'parks#set_all'

  #admin panel
  get '/admin/home', to: 'admins#home'

  mount UserImpersonate::Engine => "/impersonate", as: "impersonate_engine"

  #errors
  get '/403', to: 'welcome#error403'

  #payments trackers
  get 'payments', to:'payments_tracker#index'
  get 'payments/tracker', to:'payments_tracker#home'
  get 'payments/admin', to:'payments_tracker#admin'
  get 'payments/list', to: 'payments_tracker#list'
  get 'payments/list/add', to: 'payments_tracker#add_new_payment'
  get 'payments/sync', to: 'payments_tracker#sync'
  get 'payments/accounts/new', to: 'payments_tracker#new_account'
  post 'payments/accounts/create', to: 'payments_tracker#create_account'
  get 'payments/unassigned', to:'payments_tracker#unassigned'
  get 'payments/send_roster', to: 'payments_tracker#send_roster'
  get 'payments/divisions', to: 'payments_tracker#divisions'
  get 'payments/division/:divisionId/', to: 'payments_tracker#division', as: 'divisionId'
  get 'payments/division/:divisionId/sendEmail', to: 'payments_tracker#emailDivisionRep'
  get 'payments/division/:divisionId/sendToWebteam', to: 'payments_tracker#emailWebteam'

  # offers
  get 'alloffers', to: 'offers#all'

  # rosters
  get 'rosters/update_permissions', to: 'rosters#update_permissions'

end
