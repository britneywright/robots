require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '/dev/cu.usbmodem621' # :port path may vary
device :board, :driver => :device_info
device :red_led, :driver => :led, :pin => 13
device :green_led, :driver => :led, :pin => 12


work do

  def play
    @secret_number = rand(11)
    puts "Guess what number I'm thinking of, from 0 through 10:"
    @guess = gets.chomp.to_i
    guess_sequence
  end

  def play_again
    puts "Do you want to play again? Y or N?"
    response = gets.chomp
    if response == "Y"
      play
    else
      exit!
    end
  end

  def blink(led)
    led.on
    sleep 1
    led.off
  end

  def correct_answer
    puts "Awesome you got it!"
    2.times do
      blink(red_led)
      blink(green_led)
    end
    play_again
  end
  
  def guess_sequence
    until @secret_number == @guess do
      if @guess > @secret_number
        puts "Too high. Guess again."
        blink(red_led)
      elsif @guess < @secret_number
        puts "Too low. Guess again."
        blink(green_led)
      end
      @guess = gets.chomp.to_i
    end  
    correct_answer
  end

  play
end