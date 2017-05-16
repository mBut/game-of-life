##### [Demo] (https://fathomless-journey-40312.herokuapp.com/)

#### Quick start

Project uses ruby `2.4.1`

Easiest way to start project is [RVM](https://rvm.io/rvm/install) since project includes both `.ruby-version` and `.ruby-gemset` files. To do so install RVM by instruction provided above and than:

```
git clone https://mBut@gitlab.com/mBut/game_of_life.git
cd game_of_life
bundle install
bin/rails server
```

Application will be runned on `localhost:3000`

#### Configuration

Game behaviour can be configured in `initializers/game.rb` file

**Configuration properties:**
 - **update_interval** - time interval in seconds how often game universe must be updated (default - 1s)
 - **canvas_size** - game size in browser as array in format [width, height] (default - [200, 200])
 - **pixel_size** - size of cell in pixels in the game. :canvas_size dimensions must be evenly devisible on the provided value (default - 10)
 - **shapes_dir** - directory with shapes patterns presets. Shapes must be defined as plain text files where "x" represnets alive cell and "o" - dead cell.

Some cells patterns already included in the project and can be found in the directory `config/shapes/`

#### Tests

Application uses RSpec test suite for testing. To run all the tests execute:

```
bundle exec rspec
```

#### Implementation notes

- All the general game logic by design decoupled from the app business logic and placed in the `lib` folder. It allows to extract game module to sepearate ruby gem
- Communication with browser implemented using new Rails 5 `ActionCable` feature. It allowed easily implement all given requirements
- Seems like `ActionCable` do not apply compression to the data transfered by WS protocol. Compression can significanlty improve bandwidth and app performance on weak internet connection.
- For simplicity project do not use any database to store data. Players identifies by session_id stored in the browser's cookies and keep some meta-data in the runtime memory. That means that if application restarts stored data flushes. It can be improved.