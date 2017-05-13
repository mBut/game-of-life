require "game/base"

Game.configure do |config|
  config.grid_size = [20, 20]

  config.shapes = {
    "blinker" => [
      [0,1,0],
      [0,1,0],
      [0,1,0]
    ]
  }

  config.interval = 0.5
end

Game::Universe.start!
