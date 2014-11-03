require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '/dev/cu.usbmodem411' # :port path may vary
device :board, :driver => :device_info
device :red_led, :driver => :led, :pin => 13
device :green_led, :driver => :led, :pin => 13

secret_number = rand(11)

work do

  def blink(led)
    led.on
    sleep 1
    led.off
  end

  puts "Guess what number I'm thinking of:"
  guess = gets.chomp.to_i

  until secret_number == guess do
    if guess > secret_number
      puts "Too high. Guess again."
      blink(red_led)
    elsif guess < secret_number
      puts "Too low. Guess again."
      blink(green_led)
    end
    guess = gets.chomp.to_i
  end

  puts "Awesome you got it!"

end