require 'spec_helper'

describe WeatherCli::Weather do
  let(:location) { 'San Francisco' }
  let(:weather) { WeatherCli::Weather.new(location, 'option1', 'option2') }
  let(:correct_query) { "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"#{location}\")" }
  let(:api_results) {
    {
      "title"=>"Conditions for San Francisco, CA at 2:52 pm PST",
      "condition"=>{"code"=>"28", "date"=>"Sat, 17 Jan 2015 2:52 pm PST", "temp"=>"57", "text"=>"Mostly Cloudy"},
      "forecast"=>[
        {"code"=>"30", "date"=>"17 Jan 2015", "day"=>"Sat", "high"=>"60", "low"=>"53", "text"=>"Partly Cloudy"},
        {"code"=>"30", "date"=>"18 Jan 2015", "day"=>"Sun", "high"=>"61", "low"=>"49", "text"=>"AM Clouds/PM Sun"},
        {"code"=>"28", "date"=>"19 Jan 2015", "day"=>"Mon", "high"=>"62", "low"=>"50", "text"=>"Mostly Cloudy"},
        {"code"=>"30", "date"=>"20 Jan 2015", "day"=>"Tue", "high"=>"61", "low"=>"48", "text"=>"AM Clouds/PM Sun"},
        {"code"=>"32", "date"=>"21 Jan 2015", "day"=>"Wed", "high"=>"64", "low"=>"48", "text"=>"Sunny"}
      ]
    }
  }
  let(:title) { "Conditions for San Francisco, CA at 2:52 pm PST" }
  let(:forecasts) {
    [
      {"code"=>"30", "date"=>"17 Jan 2015", "day"=>"Sat", "high"=>"60", "low"=>"53", "text"=>"Partly Cloudy"},
      {"code"=>"30", "date"=>"18 Jan 2015", "day"=>"Sun", "high"=>"61", "low"=>"49", "text"=>"AM Clouds/PM Sun"}
    ]
  }
  let(:conditions) {
    {
      "temp"=>"57", "text"=>"Mostly Cloudy"
    }
  }

  context '#initialize' do
    it 'should map any options to a truthy hash' do
      expect(weather.options).to eq({'option1' => true, 'option2' => true})
    end
  end

  it 'should construct the correct query' do
    expect(weather.send(:construct_query, location)).to eq(correct_query)
  end

  it 'should construct the correct URL' do
    encoded_location = URI.encode(location)
    correct_url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{encoded_location}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
    expect(weather.send(:construct_url, correct_query)).to eq(correct_url)
  end

  context '#get_weather' do
    context 'with a successful api call' do
      before do
        allow_any_instance_of(WeatherCli::Weather).to receive(:retrieve_api_results).and_return(api_results)
        weather.get_weather
      end

      it 'should have a title' do
        expect(weather.title).to eq(title)
      end

      it 'should have the current condition' do
        expect(weather.conditions).to eq(conditions)
      end

      it 'should have the forecast for today and tomorrow' do
        expect(weather.forecasts.length).to eq(2)
        expect(weather.forecasts).to eq(forecasts)
      end
    end

    context 'with an unsuccessful api call' do
      before do
        allow_any_instance_of(WeatherCli::Weather).to receive(:retrieve_api_results).and_return(false)
        weather.get_weather
      end

      it 'should not set the weather attributes' do
        [:title, :conditions, :forecasts].each do |attr|
          expect(weather.send(attr)).to eq(nil)
        end
      end
    end
  end

  describe '#retrieve_api_results' do
    context 'with a failure' do
      let(:url) { 'fake_url.fake' }

      before do
        allow(JSON).to receive(:parse).and_raise(StandardError)
      end

      it 'should apologize' do
        expect { weather.send(:retrieve_api_results, url) }.to output("Sorry, something went wrong.\n").to_stderr
      end

      it 'should return false' do
        allow($stderr).to receive(:write)
        expect(weather.send(:retrieve_api_results, url)).to eq(false)
      end
    end
  end

  context '#to_s' do
    before do
      allow_any_instance_of(WeatherCli::Weather).to receive(:retrieve_api_results).and_return(api_results)
      weather.get_weather
    end

    it 'should print out the weather nicely' do
      output_string = [
        'Conditions for San Francisco, CA at 2:52 pm PST',
        '57 degrees Farenheit; Mostly Cloudy',
        "Today's forecast: High of 60, Low of 53; Partly Cloudy",
        "Tomorrow's forecast: High of 61, Low of 49; AM Clouds/PM Sun"
      ].join("\n")
      expect(weather.to_s).to eq(output_string)
    end
  end
end
