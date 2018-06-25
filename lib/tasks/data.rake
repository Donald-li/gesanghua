namespace :data do
  task migrate_city_data: [:environment] do
    path = File.join('lib', 'city_data', 'china_city.json')
    old_data = JSON.parse(File.read(path))
    provinces = []
    cities = []
    districts = []

    old_data.select{|d| d['value'] =~ /0000$/ }.each{|d| provinces << {text: d['name'], id: d['value']}}
    provinces.each do |province|
      old_data.select{|d| d['value'].start_with?(province[:id][0,2]) && d['value'] != province[:id]}.each{|d| cities << {text: d['name'], id: d['value']}}
    end
    cities.each do |city|
      old_data.select{|d| d['value'].start_with?(city[:id][0,4]) && d['value'] != city[:id]}.each{|d| districts << {text: d['name'], id: d['value']}}
    end

    data = {province: provinces, city: cities, district: districts}

    File.open(File.join('lib', 'city_data', 'new_data.json'), 'w') do |file|
      file.write data.to_json
    end
  end
end
