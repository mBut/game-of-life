class GameController < ApplicationController

  def index
    @game_config = Game.config
  end

  def register_player
    @player = Game::Player.find_or_create(session.id)
    render json: @player
  end
end
