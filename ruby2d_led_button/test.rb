require 'ruby2d'
require 'denko'

LED_PIN = 4
FONT    = "LTSuperiorMono/LTSuperiorMono-Bold.otf"

# Button and text positoning and aligment.
x = 100
y = 100
button_width  = 240
button_height = 70
text_size  = 50
text_pad_l = 16
text_pad_t = 12
on_state_alignment_offset = 13

# Button bounds
bnd = [x, y, x+button_width, y+button_height] # xmin, ymin, xmax, ymax

# Board setup
@board = Denko::Board.new(Denko::Connection::Serial.new)
@led   = Denko::LED.new(board: @board, pin: LED_PIN)

# GUI button setup
@button_rect =  Rectangle.new x: x, y: y, z: 10,
                              width: button_width, height: button_height, color: 'red'
        
@button_text =  Text.new  'LED OFF',
                x: x+text_pad_l, y: y+text_pad_t, z: 20,
                font: FONT,
                color: 'white',
                size: text_size

# When left clicked within button bounds, toggle @led.
on :mouse_down do |event|
  if (event.x <= bnd[2]) && (event.x >= bnd[0]) && (event.y <= bnd[3]) && (event.y >= bnd[1])
    if (event.button == :left)
      @led.toggle
    end
  end
end

# Wait for @led to read its initial state, so button looks correct at startup.
sleep 0.001 while (@led.state == nil)

# Use main loop to update button appearance to match LED state.
update do
  if (@led.state == 1)
    @button_rect.color = 'green'
    @button_text.text = "LED ON"
    @button_text.x = x + text_pad_l + on_state_alignment_offset
  else
    @button_rect.color = 'red'
    @button_text.text = "LED OFF"
    @button_text.x = x + text_pad_l
  end
end

show
