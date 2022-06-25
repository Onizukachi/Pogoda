module SearchCity
  
  CITIES_CODE = {
          'Москва' => 32277, 
          'Пермь' => 59, 
          'Санкт-Петербург' => 69, 
          'Новосибирск' => 99, 
          'Орел' => 115, 
          'Чита' => 121, 
          'Братск' => 141, 
          'Краснодар' => 34356
        }

  def get_city
    index_city = ''
    cities = CITIES_CODE.keys
 
   until index_city =~ (/\A[1-#{cities.size}]{1}$/)
     puts "Погоду для какого города Вы хотите узнать?" 
     cities.each_with_index { |c,i| puts "#{i+1}: #{c}"}
     index_city = gets.chomp
   end
   cities[index_city.to_i-1]
 end

  def get_html_doc(city_code)
    uri = URI("https://xml.meteoservice.ru/export/gismeteo/point/#{city_code}.xml")
    xml_doc = Document.new(Net::HTTP.get(uri))
  end
end
