require 'artoo'
require 'tweetstream'

# don't abuse my account info please
TweetStream.configure do |config|
  config.consumer_key       = 'cOWPQXxDK1WklR27E7GZUU6Cw'
  config.consumer_secret    = 'hOSeZ3yy90AR4pbwBInbL1Ubut5W2Mu63tZDql1J6zmWvsh3GA'
  config.oauth_token        = '26582920-GsSQnZKDGA6cjIBv9PbEx32TdMe1Kx3tkBDXujG8P'
  config.oauth_token_secret = 'LSM5QihfOLZDhgI5oC192vvlYFbjCTXHm8UYyIhffZuAx'
  config.auth_method        = :oauth
end

connection :firmata, :adaptor => :firmata, :port => '/dev/cu.usbmodem411' # :port path may vary
device :board, :driver => :device_info
device :red_led, :driver => :led, :pin => 13
device :green_led, :driver => :led, :pin => 12

positive = /good|easy|happy|ahead|inspire/i  
negative = /ugh|stuck|behind|fail|damn/i

# include lines 23, 25 and 42 if you want to limit the number of tweets returned.
work do
  # @statuses = []
  TweetStream::Client.new.track("#NaNoWriMo") do |status,client|
      # @statuses << status
      puts "#{status.user.screen_name} - #{status.text}\n#{status.created_at}"
      twit = status.text
      if negative.match(twit)
        puts '**sad tweet**'
        red_led.send(:on)
        sleep 3
        red_led.send(:off)
        sleep 1
      elsif positive.match(twit)
          puts '--happy tweet--'
          green_led.send(:on)
          sleep 3
          green_led.send(:off)
          sleep 1
      end
      puts "\n"
      # client.stop if @statuses.size >= 10
  end
end