# heroku run rake db:seed:set_coed
def setting_coed_divisions
  coed_divisions = ['dima', 'rainbow', 'panarace', 'pride', 'sachs', 'stonewall', 'fitzpatrick', 'open']
  puts "Setting Coed Divisions..."
  divisions = Division.all
  divisions.each do |division|
    division_name = division.description.downcase()
    puts division_name
    if (coed_divisions.any? { |div| division_name.include? div })
      puts "is coed"
      division.is_coed = true
      division.save
    else
      puts "is not coed"
      division.is_coed = false
      division.save
    end
  end
end

setting_coed_divisions