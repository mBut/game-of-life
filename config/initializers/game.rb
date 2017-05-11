require "game_config"
require "universe"
require "simple_printer"

Game.configure do |config|
  config.grid_size = [20, 20]
  config.shapes = {
    "blinker" => [
      [0,1,0],
      [0,1,0],
      [0,1,0]
    ]
  }
end
