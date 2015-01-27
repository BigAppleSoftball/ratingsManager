# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# read team CSV file and populate database

#rails generate scaffold Divisions div_id:integer season_id:integer pool_id:integer div_description:string div_order:integer standings:string team_cap:integer waitlist_cap:integer is_active:boolean 
def generate_division_backup
  csvRows = get_csv_file('divisions.csv')
  csvRows.each do |row|
    division = Division.new(
      :div_id => row[:divid],
      :season_id => row[:seasonid], 
      :pool_id => row[:poolid],
      :div_description => row[:divdesc],
      :div_order => row[:divorder],
      :standings => row[:standingstype],
      :team_cap => row[:teamcap],
      :waitlist_cap => row[:waitlistcap],
      :is_active => row[:isactive] 
      )
    division.save
  end
end
#SeasonID LeagueID  SeasonDesc  DateStart DateEnd DateRegOpen DateRegClosed DateCreated DateUpdated                            
#rails generate scaffold Seasons season_id:integer league_id:integer pool_id:integer season_desc:string  date_start :datetime date_end:datetime 
def generate_season_backup
  csvRows = get_csv_file('seasons.csv')
  csvRows.each do |row|
    season = Season.new(
      :season_id => row[:seasonid],
      :league_id => row[:leagueid],
      :pool_id => row[:poolid],
      :season_desc=> row[:seasondesc], 
      :date_start => row[:datestart],
      :date_end => row[:dateend]
      )
    season.save
  end
end

#rails generate scaffold Teams division_id:integer long_name:string stat_loss:integer stat_win:integer stat_play:integer stat_pt_allowed:integer stat_pt_scored:integer stat_tie:integer teamsnap_id:integer team_desc:text name:string 

def generate_team_backup
  csvRows = get_csv_file('teams.csv')
  csvRows.each do |row|
    team = Team.new(
    :division_id => row[:divid], 
    :long_name => row[:longname], 
    :stat_loss => row[:statlosses], 
    :stat_win => row[:statwins], 
    :stat_play => row[:statplayed], 
    :stat_pt_allowed => row[:statptsallowed],
    :stat_pt_scored => row[:statptsscored], 
    :stat_tie => row[:statties], 
    :teamsnap_id => row[:teamid], 
    :team_desc => row[:teamdesc], 
    :name => row[:teamname],
    :team_code => row[:teamcode],
    :team_status => row[:teamcode],
    :win_perc => row[:statwinsperc],
    :stat_games_back => row[:statgamesback],
    :date_created => row[:datecreated],
    :date_updated => row[:dateupdated],
    :contact => row[:teamcontact],
    :email => row[:teamemail],
    :created_user_id => row[:bycreated],
    :updated_user_id => row[:byupdated]
    )
    team.save
  end
end

def get_csv_file(fileName)
  file = File.join(Rails.root,'db', 'seeds', fileName)
  data = File.read(file)
  csv =  CSV.new(data, :headers => true,:header_converters => :symbol)
  csvRows = csv.to_a.map
  csvRows
end

#generate_team_backup
#generate_division_backup
generate_season_backup