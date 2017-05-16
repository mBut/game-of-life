require "game"

RSpec.describe Game::Player do
  it ".find_or_create" do
    expect(Game::Player.find_or_create(1)).to be_instance_of(Game::Player)
  end

  it ".find" do
    player = Game::Player.find_or_create(2)
    expect(Game::Player.find(2)).to eq player
  end

  it "#new" do
    player = Game::Player.new
    expect(player.color).to match(/^#\w{6}$/)
  end

end
