module WeatherCli
  require 'net/http'
  require 'json'

  class Weather
    attr_reader :location, :conditions, :options, :title, :forecasts

    def initialize(location, *options)
      @options = Hash[options.map { |o| [o, true] }]
      get_weather(location)
    end

    def to_s
      todays_forecast = forecasts.first
      tomorrows_forecast = forecasts.last
      [
        title,
        "#{conditions['temp']} degrees Farenheit; #{conditions['text']}",
        "Today's forecast: High of #{todays_forecast['high']}, Low of #{todays_forecast['low']}; #{todays_forecast['text']}",
        "Tomorrow's forecast: High of #{tomorrows_forecast['high']}, Low of #{tomorrows_forecast['low']}; #{tomorrows_forecast['text']}"
      ].join("\n")
    end

    private

    def get_weather(location)
      query = construct_query(location)
      url = construct_url(query)
      parse_api_results(retrieve_api_results(url))
    end

    def construct_query(location)
      "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"#{location}\")"
    end

    def construct_url(query)
      base_url = "https://query.yahooapis.com/v1/public/yql"
      encoded_query = URI.encode(query).gsub('=', '%3D')
      options = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      "#{base_url}?q=#{encoded_query}#{options}"
    end

    def retrieve_api_results(url)
      JSON.parse(Net::HTTP::get(URI.parse(url)))['query']['results']['channel']['item']
    end

    def parse_api_results(results)
      @title = results['title']
      @conditions = results['condition'].keep_if { |k,v| ['temp','text'].include? k }
      @forecasts = results['forecast'].first(2)
    end
  end
end

