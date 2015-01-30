module WeatherCli
  require 'net/http'
  require 'json'

  class Weather
    attr_reader :location, :conditions, :options, :title, :forecasts

    def initialize(location, *options)
      @location = location
      @options = Hash[options.map { |o| [o, true] }]
    end

    def to_s
      return '' unless title && conditions && forecasts
      todays_forecast = forecasts.first
      tomorrows_forecast = forecasts.last
      [
        title,
        "#{conditions['temp']} degrees Farenheit; #{conditions['text']}",
        "Today's forecast: High of #{todays_forecast['high']}, Low of #{todays_forecast['low']}; #{todays_forecast['text']}",
        "Tomorrow's forecast: High of #{tomorrows_forecast['high']}, Low of #{tomorrows_forecast['low']}; #{tomorrows_forecast['text']}"
      ].join("\n")
    end

    def get_weather
      query = construct_query(@location)
      url = construct_url(query)
      results = retrieve_api_results(url)
      if results
        parse_api_results(results)
      end
    end

    private

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
      begin
        results_hash = JSON.parse(Net::HTTP::get(URI.parse(url)))
        raise unless results_hash['query'] && results_hash['query']['results']
      rescue => _
        $stderr.puts 'Sorry, something went wrong.'
        return false
      else
        results_hash['query']['results']['channel']['item']
      end
    end

    def parse_api_results(results)
      @title = results['title']
      @conditions = results['condition'].keep_if { |k,v| ['temp','text'].include? k }
      @forecasts = results['forecast'].first(2)
    end
  end
end

