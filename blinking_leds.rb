require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '/dev/cu.usbmodem411' # :port path may vary
device :board, :driver => :device_info
device :red_led, :driver => :led, :pin => 13
device :green_led, :driver => :led, :pin => 12

work do

  green_led.on
  red_led.on

  every 1.second do
    green_led.on? ? green_led.off : green_led.on
  end

  every 2.second do
    red_led.on? ? red_led.off : red_led.on
  end
end