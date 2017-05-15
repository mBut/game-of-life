class GameController < ApplicationController

  def index
    @shapes = Game::Shape.all
  end

  def register_player
    @player = Game::Player.find_or_create(session.id)
    render json: @player
  end

end
