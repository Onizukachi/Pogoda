require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

require_relative 'lib/forecast'
require_relative 'lib/search_city'

include REXML
include SearchCity

city = get_city

city_code = CITIES_CODE[city]

xml_doc = get_html_doc(city_code)

city_name = URI.decode_www_form_component(XPath.first(xml_doc, "//TOWN").attributes['sname'])

forecasts = XPath.match(xml_doc, '//FORECAST').map { |f| Forecast::Forecast.from_xml f}

puts "______________[ #{city_name} ]_________________"

forecasts.sort.each { |x| puts x }
