# GameChannel broadcasts game updates to each player
class GameChannel < ApplicationCable::Channel

  def self.update(universe)
    broadcast_to(Game.universe, universe)
  end

  def subscribed
    stream_for Game.universe
  end

  def throw_shape(data)
    shape = Game::Shape.find(data["shape"])
    Game.universe.throw_shape(shape, player.color) if shape
  end

  def add_cell(data)
    pixel_size = Game.config.pixel_size
    cell_x = (data["x"] / pixel_size).floor
    cell_y = (data["y"] / pixel_size).floor

    Game.universe.add_cell(player.color, cell_x, cell_y)
  end

  private

  def player
    Game::Player.find(session)
  end

end
