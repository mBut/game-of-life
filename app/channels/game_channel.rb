class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for Game.universe
  end

  def throw_shape(data)
    shape_mask = Game.config.shapes[data["shape"]]
    if shape_mask
      player = Game::Player.find(session)
      Game.universe.throw_shape(shape_mask, player.color)
    end
  end

  def self.update(universe)
    broadcast_to(Game.universe, universe)
  end
end
