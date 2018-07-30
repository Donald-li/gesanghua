namespace :data do
  task migrate_city_data: [:environment] do
    path = File.join('lib', 'city_data', 'china_city.json')
    old_data = JSON.parse(File.read(path))
    provinces = []
    cities = []
    districts = []

    old_data.select{|d| d['value'] =~ /0000$/ }.each{|d| provinces << {text: d['name'], id: d['value']}}
    provinces.each do |province|
      old_data.select{|d| d['value'] =~ /00$/ && d['value'].start_with?(province[:id][0,2]) && d['value'] != province[:id]}.each{|d| cities << {text: d['name'], id: d['value']}}
    end
    cities.each do |city|
      old_data.select{|d| d['value'].start_with?(city[:id][0,4]) && d['value'] != city[:id]}.each{|d| districts << {text: d['name'], id: d['value']}}
    end

    data = {province: provinces, city: cities, district: districts}

    File.open(File.join('lib', 'city_data', 'new_data.json'), 'w') do |file|
      file.write data.to_json
    end
  end

  task migrate_to_weui_data: [:environment] do
    path = File.join('lib', 'city_data', 'china_city.json')
    old_data = JSON.parse(File.read(path))
    provinces = []

    old_data.select{|d1| d1['value'] =~ /0000$/ }.each do |pro|
      province = {label: pro['name'], value: pro['value']}
      old_data.select{|d2| d2['value'] =~ /00$/ && d2['value'].start_with?(province[:value][0,2]) && d2['value'] != province[:value]}.each do |cit|
        city = {label: cit['name'], value: cit['value']}
        old_data.select{|d3| d3['value'].start_with?(city[:value][0,4]) && d3['value'] != city[:value]}.each do |dis|
          district = {label: dis['name'], value: dis['value']}
          city[:children] ||= []
          city[:children] << district
        end
        province[:children] ||= []
        province[:children] << city
      end
      provinces << province
    end

    data = provinces

    File.open(File.join('lib', 'city_data', 'weui_data.json'), 'w') do |file|
      file.write data.to_json
    end
  end


end
