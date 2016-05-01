def setting_coed_divisions
  coed_divisions = ['dima', 'rainbow', 'panarace', 'pride', 'sachs', 'stonewall', 'fitzpatrick', 'open']
  puts "Setting Coed Divisions..."
  divisions = Division.all
  divisions.each do |division|
    division_name = division.description.downcase()
    if (coed_divisions.any? { |div| division_name.include? div })
      division.is_coed = true
      division.save
    end
  end
end

setting_coed_divisions