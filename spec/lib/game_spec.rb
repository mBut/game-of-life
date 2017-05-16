require "game"

RSpec.describe Game do
  it ".game" do
    Game.configure
    expect(Game.universe).to eq Game::Universe.instance
  end

  describe ".configure" do
    it "without params setups game to default config" do
      Game.configure
      expect(Game.config.update_interval).to eq Game::Config::DEFAULT_UPDATE_INTERVAL
    end

    it "allows configuration using block" do
      Game.configure do |config|
        config.update_interval = 2
      end
      expect(Game.config.update_interval).to eq 2
    end
  end
end
