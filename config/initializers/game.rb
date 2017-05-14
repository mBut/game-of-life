require "game/base"

Game.configure do |config|
  config.size = [600, 400]
  config.pixel_size = 10

  config.shapes = Game::Util.load_shapes_from_dir("#{Rails.root}/config/shapes")

  config.interval = 0.5
end

Game::Universe.instance.add_observer(GameChannel)
Game::Universe.start!
