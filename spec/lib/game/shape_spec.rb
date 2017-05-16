require "game"
require "tempfile"

RSpec.describe Game::Shape do
  let(:shape1) { Game::Shape.new("foo", [[0, 1, 0], [1, 0, 1]]) }
  let(:shape2) { Game::Shape.new("bar", [[1, 0, 1, 0]]) }

  describe ".find" do
    before do
      allow(Game::Shape).to receive(:all) do
        [shape1, shape2]
      end
    end

    it "should find shape by id" do
      expect(Game::Shape.find("bar")).to eq shape2
    end
  end

  it ".from_string" do
    string = "o x x\nx o x"
    shape = Game::Shape.from_string("custom_shape", string)
    expect(shape.id).to eq "custom_shape"
    expect(shape.pattern).to eq [[0, 1, 1], [1, 0, 1]]
  end

  it ".from_file" do
    file = Tempfile.new("shape_file")
    begin
      file.write("x o o")
      file.rewind

      filename = file.path.split("/").last

      expect(Game::Shape).to receive(:from_string).with(filename, "x o o")
      Game::Shape.from_file file
    ensure
      file.close
      file.unlink
    end
  end

  it "#width" do
    expect(shape1.width).to eq 3
    expect(shape2.width).to eq 4
  end

  it "#height" do
    expect(shape1.height).to eq 2
    expect(shape2.height).to eq 1
  end
end
