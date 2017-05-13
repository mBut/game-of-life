// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

  App.cable.subscriptions.create("GameChannel", {
    connected: function() { console.log("Consumer connected") },
    received: function(universe) {
      universe.forEach(function(row, i){
        row.forEach(function(cell, j) {
          if (!cell) {
            App.gameContext.clearRect(i * 10, j * 10, 10, 10);
          } else {
            App.gameContext.fillStyle = cell
            App.gameContext.fillRect(i * 10, j * 10, 10, 10);
          }
        });
      });
    },
    addShape: function(shape, x, y) {
      this.perform("add_shape", { name: "blinker", x: x, y: y });
    }
  })

}).call(this);
