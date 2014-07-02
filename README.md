## EaselJS + Box2d
A coffeescript implementation of the basics of a side-scroller game utilizing the [EaselJS](www.createjs.com/#!/EaselJS) and [Box2D](https://code.google.com/p/box2dweb/) libraries.

![Gameplay](https://cloud.githubusercontent.com/assets/871454/3457199/51e2b25e-01f6-11e4-8625-1ebe3c36d200.png)

### Installation

#### Install Gulp
```bash
$ npm install -g gulp
```

#### Install Dependencies
```bash
$ git clone git@github.com:tommymarshall/easeljs-box2d-example.git
$ cd easeljs-box2d-example
$ npm install
$ gulp
```

### Development
While running `gulp` from the command line, any images, coffeescript, or .html files that are saved will automatically be optimized, compiled or copied and added to the `build` directory.
Relavent files for the game are all saved in `source/javascripts/` directory as .coffee files.