Rails.application.routes.draw do

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

  get '/getleaguesponsors', to: 'sponsors#league_sponsors'
  root 'welcome#login'

  get '/teamssnap/:teamId/:rosterId', to: 'welcome#team', as: 'rosterId'
  get '/ranking/:teamId/:rosterId/:playerId', to: 'welcome#ranking', as: 'playerId'
  get '/welcome', to: 'welcome#index'
  get '/login', to: 'welcome#login'
  get '/logout', to: 'welcome#logout'
  post '/teamsnaplogin', to: 'welcome#teamsnaplogin'
  get '/showallsponsors', to: 'sponsors#all_sponsors'
  get '/sponsorscarousel', to: 'sponsors#sponsor_carousel'
  get '/showallhof', to: 'hallof_famers#all_hof'
  get '/showallboard', to: 'board_members#all_board'
  get '/loadsidebar', to: 'welcome#basl_sidebar'

  #admin panel
  get '/admin/home', to: 'admins#home'
  get '/403', to: 'welcome#error403'

end
