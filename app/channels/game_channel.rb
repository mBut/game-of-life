# GameChannel broadcasts game updates to each player
class GameChannel < ApplicationCable::Channel

  def subscribed
    stream_for Game.universe
  end

  def throw_shape(data)
    shape = Game::Shape.find(data["shape"])

    if shape
      player = Game::Player.find(session)
      Game.universe.throw_shape(shape, player.color)
    end
  end

  def self.update(universe)
    broadcast_to(Game.universe, universe)
  end

end
