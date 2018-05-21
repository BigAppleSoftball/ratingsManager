# heroku run rake db:seed:set_nagaaa_id
def get_csv_file(fileName)
  file = File.join(Rails.root,'db', 'seeds', fileName)
  data = File.read(file)
  csv =  CSV.new(data, :headers => true,:header_converters => :symbol)
  csvRows = csv.to_a.map
  csvRows
end


def run
  puts 'Running Import of NAGAAA Ids'
  csvRows = get_csv_file('nagaaa_ids.csv')
  no_id_string = ''
  no_player_string = ''
  csvRows.each do |row|
    playerId = row[:nagaaa_player_id]
    fName = row[:first_name]
    lName = row[:last_name]
    email = row[:email]

    if (playerId.nil?)
      no_id_string += "NO ID, #{fName}, #{lName}, #{email} \n"
    else
      # try to find a player by email first
      profile = Profile.where('lower(email) = ?', email.downcase).first
      if (!profile.present?)
        # search on lastname and first name
        profile = Profile.where('lower(first_name) = ? AND lower(last_name) = ?', fName, lName).first

        # Player Still not found on ID
        if !profile.present?
          no_player_string += "#{playerId},#{fName}, #{lName}, #{email} \n" 
          end
      else

      end
      # insert nagaaa id into profile
      if (profile.present?)
        profile.nagaaa_id = playerId.to_i
        profile.save
      end
    end
  end
  puts no_player_string
  puts no_id_string
end

run