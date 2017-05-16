require "game"

RSpec.describe Game::Universe do
  let(:square_shape) { Game::Shape.new("square", [[1, 1], [1, 1]]) }

  before(:all) do
    Game.configure do |config|
      config.canvas_size = [30, 20]
      config.pixel_size = 2
    end

    @game = Game::Universe.instance
  end

  before(:each) do
    @game.reset
  end

  it "#evolve" do
    expect(@game).to receive(:updated)
    expect(@game).to receive(:evolved_cell_state).exactly(@game.width * @game.height).times

    @game.evolve
  end

  describe "#evolved_cell_state" do
    it "dead cell should be live with exactly 3 neighbours" do
      expect(@game.grid[2][2]).to be_nil
      expect(@game).to receive(:cell_neighbours).with(2, 2).and_return([3, "red"])
      expect(@game.evolved_cell_state(2, 2)).to eq "red"
    end

    it "live cell should die with more than 3 neighbours" do
      @game.add_cell("purple", 3, 6)

      expect(@game).to receive(:cell_neighbours).with(3, 6).and_return([4, "purple"])
      expect(@game.evolved_cell_state(3, 6)).to be_nil
    end

    it "live cell should die with less than 2 neighbours" do
      @game.add_cell("purple", 4, 2)

      expect(@game).to receive(:cell_neighbours).with(4, 2).and_return([1, "red"])
      expect(@game.evolved_cell_state(4, 2)).to be_nil
    end

    it "live cell should live with 2 or 3 neighbours" do
      @game.add_cell("green", 1, 3)

      expect(@game).to receive(:cell_neighbours).with(1, 3).and_return([3, "yellow"])
      expect(@game.evolved_cell_state(1, 3)).to eq "green"
    end

  end

  describe "#cell_neighbours" do
    it "when there are no neighbours" do
      neighbours_count, dominant_color = @game.cell_neighbours(4, 3)
      expect(neighbours_count).to eq 0
      expect(dominant_color).to be_nil
    end

    it "when there is one neighbour" do
      @game.add_cell("red", 3, 6)
      neighbours_count, dominant_color = @game.cell_neighbours(4, 6)
      expect(neighbours_count).to eq 1
      expect(dominant_color).to eq "red"
    end

    it "when there is multiple neighbours" do
      @game.add_cell("green", 2, 1)
      @game.add_cell("blue", 2, 2)
      @game.add_cell("green", 4, 3)
      neighbours_count, dominant_color = @game.cell_neighbours(3, 2)
      expect(neighbours_count).to eq 3
      expect(dominant_color).to eq "green"
    end
  end

  it "#add_cell" do
    expect(@game.grid[6][2]).to be_nil

    expect(@game).to receive(:updated)

    @game.add_cell("yellow", 2, 6)

    expect(@game.grid[6][2]).to eq "yellow"
  end

  it "#add_shape" do
    expect(@game.grid[3][3]).to be_nil
    expect(@game.grid[3][4]).to be_nil
    expect(@game.grid[4][3]).to be_nil
    expect(@game.grid[4][4]).to be_nil

    expect(@game).to receive(:updated)

    @game.add_shape(square_shape, "red", 3, 3)

    expect(@game.grid[3][3]).to eq "red"
    expect(@game.grid[3][4]).to eq "red"
    expect(@game.grid[4][3]).to eq "red"
    expect(@game.grid[4][4]).to eq "red"
  end

  it "#throw_shape" do
    expect(@game).to receive(:add_shape).with(square_shape, "black", kind_of(Numeric), kind_of(Numeric))
    @game.throw_shape(square_shape, "black")
  end

end
