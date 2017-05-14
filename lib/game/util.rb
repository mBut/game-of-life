class Game::Util

  DEAD_CELL_CHARS = %w{o 0}
  LIVE_CELL_CHARS = %w{x 1}

  def self.load_shapes_from_dir(dir)
    shapes = {}

    Dir["#{dir}/*"].each do |file|
      shape_name = File.basename(file, ".*").downcase
      shape_mask = File.read(file).split("\n").map do |line|
        line.split(/\s+/).map do |char|
          if DEAD_CELL_CHARS.include?(char)
            0
          elsif LIVE_CELL_CHARS.include?(char)
            1
          else
            raise "Don't know how to process char '#{char}'"
          end
        end
      end

      shapes[shape_name] = shape_mask
    end

    shapes
  end

end
