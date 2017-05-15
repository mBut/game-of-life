# Shape class represents shapes that can be formed by cells and placed in the universe
# All the shapes reads from the files placed in one directory specified by `Game.config.shapes_dir`
# Shapes are not cached. It allows to add/modify shapes at the runtime if required.
class Game::Shape

  # Char that describe "dead" cell in string representation
  DEAD_CELL_CHAR = "o"

  # Char that describe "live" cell in string representation
  LIVE_CELL_CHAR = "x"

  attr_reader :id, :pattern
  alias :name :id

  def initialize(id, pattern)
    @id = id
    @pattern = pattern

    self
  end

  def self.find(id)
    all.find{ |shape| shape.id == id }
  end

  # Initialize all the shapes by pattern files in the given by configuration directory
  def self.all
    Dir["#{Game.config.shapes_dir}/*"].map{ |filename| from_file(filename) }
  end

  # Load shape from file. Lowercased file name is used as shape identifier
  def self.from_file(filename)
    from_string(File.basename(filename, ".*").downcase, File.read(filename))
  end

  # Load shape from string
  def self.from_string(id, string)
    pattern = string.split("\n").map do |line|
      line.split(/\s+/).map do |char|
        case char
        when DEAD_CELL_CHAR
          0
        when LIVE_CELL_CHAR
          1
        else
          raise "Don't know how to process char '#{char}'"
        end
      end
    end

    new(id, pattern)
  end

  def width
    pattern.first.size
  end

  def height
    pattern.size
  end

end
