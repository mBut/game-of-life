class Game
  constructor: ($scope) ->
    @App || (@App = {})
    @$scope = $scope
    @$canvas = $("canvas", @$scope)
    @context = @$canvas[0].getContext('2d')
    @pixelSize = @$canvas.data("pixelSize")

  initialize: (player) =>
    $(".player-color", @$scope).css("backgroundColor", player.color)
    $(".toolbar", @$scope).removeClass("collapsed")

    @gameChannel = App.cable.subscriptions.create "GameChannel",
      received: @updateUniverse

    @$canvas.on "click", (e) =>
      @gameChannel.perform "add_cell", x: e.offsetX, y: e.offsetY

  updateUniverse: (universe) =>
    self = this
    universe.forEach (row, i) ->
      row.forEach (cell, j) ->
        cellX = j * self.pixelSize
        cellY = i * self.pixelSize

        if !cell
          self.context.clearRect(cellX, cellY, self.pixelSize, self.pixelSize)
        else
          self.context.fillStyle = cell
          self.context.fillRect(cellX, cellY, self.pixelSize, self.pixelSize)

  throwShape: (shape) =>
    @gameChannel.perform "throw_shape", shape: shape

  addCell: (cellX, cellY) =>


# Start game
$(document).ready ->
  $scope = $("#game-page")
  return if $scope.length == 0

  game = new Game($scope)

  $.post "/game/register_player", game.initialize

  $(".shape-btn", $scope).on "click", (e) ->
    e.preventDefault()
    game.throwShape($(e.currentTarget).data("shape"))

