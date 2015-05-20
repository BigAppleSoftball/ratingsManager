Rails.application.routes.draw do

  root 'static_pages#home'

  resources :admins
  resources :board_members
  resources :committees
  resources :divisions
  resources :games
  resources :hallof_famers
  resources :offers
  resources :profiles do
    get 'merge'
    post 'merge', :action => 'run_merge'
  end
  resources :ratings, :only => [:index]
  resources :rosters, :only => [:destroy]
  resources :teams
  resources :teamsnap_payments
  resources :teams_sponsors
  resources :sessions, only: [:new, :create, :destroy]
  resources :seasons
  resources :sessions, only: [:new, :create, :destroy]
  resources :sponsors
  
  resources :parks do
    resources :fields
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
  post "/password_resets/new", to: 'password_resets#create'
  
  # games
  get '/games/:id/:teamid', to: 'games#game_attendance'
  post '/set_attendance', to: 'game_attendances#set_attendance'

  get '/home', to:'static_pages#home'
  get '/contact', to:'static_pages#contact'

  # seasons
  get '/get_divisions_by_season', to:'seasons#get_divisions_by_season'
  get '/season/:seasonId/games', to:'seasons#games'

  # sessions
  match '/signup',  to: 'profiles#new', via: 'get'
  match '/signin',  to: 'sessions#new', via: 'get'
  get '/signout', to: 'sessions#destroy', via: 'delete'
  get '/teams_by_season', to: 'teams#get_teams_by_season'

  post '/add_player_to_roster', to: 'rosters#add_player_to_roster'

  get '/welcome', to: 'welcome#index'

  # sponsors
  get '/season_sponsors/:season_id', to: 'teams_sponsors#season_sponsors'

  #teamsnap api login
  get '/teamsnap/login', to: 'teamsnap#login'
  post '/teamsnap/login', to: 'teamsnap#teamsnaplogin'
  get '/teamsnap/logout', to: 'teamsnap#logout'
  get 'teamsnap/index', to:'teamsnap#index'
  get '/teamssnap/:teamId/:rosterId', to: 'teamsnap#team', as: 'rosterId'
  get '/ranking/:teamId/:rosterId/:playerId', to: 'teamsnap#ranking', as: 'playerId'
  get '/teamsnap', to:'teamsnap#redirect'
  get '/teamsnap/updateplayer', to:'payments_tracker#update_teamsnap_player'
  post '/teamsnap/divisions/import', to:'teamsnap#import_season_data'

  # teams
  get '/teams/:teamid/ratings', to:'teams#show_player_ratings'

  # ratings
  post '/ratings/update', to:'ratings#update_player'
  post '/ratings/new', to:'ratings#new_player'

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
  get 'payments/divisions', to: 'payments_tracker#divisions'
  get 'payments/division/:divisionId/', to: 'payments_tracker#division', as: 'divisionId'
  get 'payments/division/:divisionId/sendEmail', to: 'payments_tracker#emailDivisionRep'
  get 'payments/division/:divisionId/sendToWebteam', to: 'payments_tracker#emailWebteam'
  get 'payments/divisions/sendAll', to: 'payments_tracker#send_all_emails'

  # offers
  get 'alloffers', to: 'offers#all'

  # rosters
  get 'rosters/update_permissions', to: 'rosters#update_permissions'

  # divisions
  get 'teamsnap/divisions/import', to: 'teamsnap#import_divisions'

  # profiles
  get 'pickup', to: 'profiles#pickup_players'
  get 'profile_details', to: 'profiles#details'

  get "/404", :to => "errors#error_404"
  get "/422", :to => "errors#error_404"
  get "/500", :to => "errors#error_500"
  get '/403', to: 'errors#error_403'

end
