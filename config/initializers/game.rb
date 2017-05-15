require "game/game"

Game.configure do |config|
  config.canvas_size = [600, 400]
  config.pixel_size = 10
  config.shapes_dir = "#{Rails.root}/config/shapes"
  config.update_interval = 0.5
end

universe = Game.universe
universe.add_observer(GameChannel)
universe.start
at_exit { universe.stop }
