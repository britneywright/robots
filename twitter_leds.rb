require 'artoo'
require 'tweetstream'

TweetStream.configure do |config|
  config.consumer_key = ENV.fetch 'CONSUMER_KEY'
  config.consumer_secret = ENV.fetch 'CONSUMER_SECRET'
  config.oauth_token = ENV.fetch 'OAUTH_TOKEN'
  config.oauth_token_secret = ENV.fetch 'OAUTH_TOKEN_SECRET'
  config.auth_method = :oauth
end

connection :firmata, :adaptor => :firmata, :port => '/dev/cu.usbmodem411' # :port path may vary
device :board, :driver => :device_info
device :red_led, :driver => :led, :pin => 13
device :green_led, :driver => :led, :pin => 12

positive = /good|easy|happy|ahead|inspire/i  
negative = /ugh|stuck|behind|fail|damn/i

# include lines 22, 24 and 41 if you want to limit the number of tweets returned.
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