module WeatherCli

  module Cli
    module_function

    def location
      if location_args
        print "Save as default location? [y/n]: "
        if user_input.downcase == 'y'
          save_default_location(location_args)
        end
        location_args
      elsif File.file?(config_file)
        File.read(config_file)
      else
        print "Add default location [e.g. San Francisco, CA]:  "
        location = user_input
        save_default_location(location)
        location
      end
    end

    def config_file
      File.join(Dir.home, ".weathercli")
    end

    def save_default_location(location)
      File.open(config_file, 'w').write(location)
    end

    def user_input
      STDIN.gets.chomp
    end

    def location_args
      ARGV.join unless ARGV.empty?
    end
  end
end
