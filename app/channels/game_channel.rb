class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game::Universe.instance
    game.add_player(session, self)
    stream_for game
  end

  def add_shape(data)
    shape_mask = Game.config.shapes[data["name"]]
    if shape_mask
      x, y = data.values_at("x", "y")
      Game::Universe.instance.add_shape_by_mask(session, shape_mask, x, y)
    end
  end

  def update(universe)
    GameChannel.broadcast_to(Game::Universe.instance, universe)
  end
end
