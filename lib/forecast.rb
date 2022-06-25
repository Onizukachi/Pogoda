module Forecast
  class Forecast
    include Comparable

    CLOUDINESS = %w[Ясно Малооблачно Облачно Пасмурно]
    TOD = %w[ночь утро день вечер]  # TIME_OF_DAY

    attr_reader :date, :temp_info, :wind_info, :cloud, :tod

    def initialize(params)
      @date = params[:date]
      @tod = params[:tod]
      @temp_info = params[:temp_info]
      @wind_info = params[:wind_info]
      @cloud = params[:cloud]
    end

    class << self
      def from_xml(doc)
        new(
          date: parse_date(doc),
          tod: TOD[doc.attributes['tod'].to_i],
          cloud: get_cloud(doc),
          wind_info: get_wind_info(doc),
          temp_info: get_temp(doc)
        )
      end

      private

      def parse_date(xml)
        new_hash = xml.attributes.map { |k, v| [k.to_sym, v.to_i] }.to_h
        DateTime.new(new_hash[:year], new_hash[:month], new_hash[:day], new_hash[:hour], 0, 0, '+24:00')
      end
  
      def get_temp(xml)
        xml.elements['TEMPERATURE'].attributes.to_a.map { |x| [(x.name).to_sym, (x.to_s).to_i] }.to_h
      end
  
      def get_wind_info(xml)
        xml.elements['WIND'].attributes.to_a.first(2).map { |x| [(x.name).to_sym, (x.to_s).to_i] }.to_h
      end
  
      def get_cloud(xml)
        cloud_index = xml.elements['PHENOMENA'].attributes['cloudiness'].to_i
        CLOUDINESS[cloud_index]
      end
    end

    def <=>(other)
      self.date <=> other.date
   end

   def to_s
    if Date.today == Date.parse(date.to_s)
      result = "Сегодня, #{tod}\n"
    else
      result =  @date.strftime("%d.%m.%Y") + ", #{tod}\n"
    end

    result << get_range_temp
    result << ", Ветер максимальный #{wind_info[:max]} м/с, #{cloud}\n"
    result << '_' * 50
   end

   private

   def get_range_temp
    min_sign = @temp_info[:min] >= 0 ? '+' : ''
    max_sign = @temp_info[:max] >= 0 ? '+' : ''
    return "#{min_sign}#{temp_info[:min]}..#{max_sign}#{temp_info[:max]}"
   end
  end
end

