Rails.application.routes.draw do
  get "/game", to: "game#index"
  post "/game/register_player", to: "game#register_player"

  root to: "game#index"
end
