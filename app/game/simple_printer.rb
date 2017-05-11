class Game::SimplePrinter
  def update(universe)
    universe.each do |row|
      puts row.join(" ")
    end
  end
end
