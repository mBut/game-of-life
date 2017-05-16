# Each player is initialized with randomly generated color
# All the players saved in the runtime memory by given id
# what means that player data is not persistent between application restarts
#
# Current implementation has no restructions on the max players count.
# However it could be wise to limit players count using some configurable number provided by Game.config
# and as well reject all new WS connections in case if limit reached.
# It also requires some session invalidation logic based on player activity.
# Perhaps better approach could be to keep session in such memoery based storages as Redis or Memcache
# with specified TTL.
class Game::Player

  @players = {}

  attr_accessor :color

  # Finds user in storage OR creates new if user not found
  def self.find_or_create(id)
    @players[id] ||= self.new
  end

  # Finds user in storage
  def self.find(id)
    @players[id]
  end

  def initialize
    generate_random_color!
    self
  end

  private

  # Pick and set random color from the entire pallete
  def generate_random_color!
    self.color = "#%02x%02x%02x" % [rand(255), rand(255), rand(255)]
  end

end
