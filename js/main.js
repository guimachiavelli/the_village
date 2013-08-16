(function() {
  var Building, Element, Person, Tile, World, grass, root, tree, water,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Element = (function() {
    function Element(world) {
      this.world = world;
    }

    Element.prototype.addToGrid = function(coord, el, type, occupy) {
      this.world.matrix[coord[0]][coord[1]][type] = el;
      return this.world.matrix[coord[0]][coord[1]].occupied = occupy;
    };

    Element.prototype.printElement = function() {
      return '<b class="' + this.name + '">' + this.symbol + '</b>';
    };

    Element.prototype.checkBounds = function(the_position) {
      if (this.world.matrix[the_position[0]] == null) {
        return false;
      } else if (this.world.matrix[the_position[0]][the_position[1]] == null) {
        return false;
      }
    };

    Element.prototype.act = function() {
      return true;
    };

    Element.prototype.defineArea = function(position, radius) {
      var around, column_length, i, row_length, x_current, x_max_length, x_min_length, y_current, y_max_length, y_min_length;
      if (position.length > 2) {
        return void 0;
      }
      around = [];
      i = 1;
      while (i <= radius) {
        y_max_length = position[0] + i;
        y_min_length = position[0] - i;
        y_current = position[0];
        x_max_length = position[1] + i;
        x_min_length = position[1] - i;
        x_current = position[1];
        column_length = this.world.height;
        row_length = this.world.width;
        if (x_max_length < row_length) {
          around.push(this.world.matrix[y_current][x_max_length]);
        }
        if (x_min_length >= 0) {
          around.push(this.world.matrix[y_current][x_min_length]);
        }
        if (y_max_length < column_length) {
          around.push(this.world.matrix[y_max_length][x_current].name);
          if (x_max_length < row_length) {
            around.push(this.world.matrix[y_max_length][x_max_length]);
          }
          if (x_min_length >= 0) {
            around.push(this.world.matrix[y_max_length][x_min_length]);
          }
        }
        if (y_min_length >= 0) {
          around.push(this.world.matrix[y_min_length][x_current].name);
          if (x_max_length < row_length) {
            around.push(this.world.matrix[y_min_length][x_max_length]);
          }
          if (x_min_length >= 0) {
            around.push(this.world.matrix[y_min_length][x_min_length]);
          }
        }
        i++;
      }
      return around;
    };

    Element.prototype.surroundings = function() {
      return this.defineArea(this.position, 1);
    };

    return Element;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.Element = Element;

  Person = (function(_super) {
    __extends(Person, _super);

    function Person(name, position, symbol, world) {
      this.name = name;
      this.position = position;
      this.symbol = symbol;
      this.world = world;
    }

    Person.prototype.move = function(axis, direction, distance) {
      var previous;
      if (distance == null) {
        distance = 1;
      }
      previous = this.position.slice(0, 2);
      switch (axis) {
        case 'y':
          if (direction === '+') {
            this.position[0] = this.position[0] + 1;
          } else if (direction === '-') {
            this.position[0] = this.position[0] - 1;
          } else {
            throw 'invalid direction';
          }
          break;
        case 'x':
          if (direction === '+') {
            this.position[1] = this.position[1] + 1;
          } else if (direction === '-') {
            this.position[1] = this.position[1] - 1;
          } else {
            throw 'invalid direction';
          }
          break;
        default:
          throw 'invalid axis';
      }
      if (this.checkBounds(this.position) != null) {
        this.position = previous;
      }
      if (this.world.matrix[this.position[0]][this.position[1]].occupied === true) {
        this.position = previous;
      } else {
        this.world.matrix[previous[0]][previous[1]].person = '';
        this.world.matrix[previous[0]][previous[1]].occupied = false;
      }
      return this.addToGrid(this.position, this, 'person', true);
    };

    Person.prototype.initialize = function() {
      return this.addToGrid(this.position, this, 'person', true);
    };

    Person.prototype.act = function(test) {
      if (test === '') {
        test = Math.floor(Math.random() * 4);
      }
      switch (test) {
        case 0:
          return this.move('x', '+');
        case 1:
          return this.move('y', '+');
        case 2:
          return this.move('x', '-');
        case 3:
          return this.move('y', '-');
      }
    };

    return Person;

  })(Element);

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.Person = Person;

  Tile = (function(_super) {
    __extends(Tile, _super);

    function Tile(name, symbol, color) {
      this.name = name;
      this.symbol = symbol;
      this.color = color;
    }

    return Tile;

  })(Element);

  grass = new Tile('grass', '.', '#0d9');

  water = new Tile('water', '.', '#000bff');

  tree = new Tile('tree', '&', '#0fb');

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.Tile = Tile;

  Building = (function(_super) {
    __extends(Building, _super);

    function Building(size) {
      this.size = size;
    }

    return Building;

  })(Element);

  World = (function() {
    function World(name, width, height) {
      this.name = name;
      this.width = width;
      this.height = height;
      this.turnCounter = 0;
      this.matrix = [];
      this.stage = [];
    }

    World.prototype.speed = 1;

    World.prototype.initialize = function() {
      var i, row, _i, _j, _len, _ref, _ref1, _results;
      for (_i = 0, _ref = this.height; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--) {
        this.matrix.push([]);
      }
      _ref1 = this.matrix;
      _results = [];
      for (i = _j = 0, _len = _ref1.length; _j < _len; i = ++_j) {
        row = _ref1[i];
        _results.push((function() {
          var _k, _ref2, _results1;
          _results1 = [];
          for (_k = 0, _ref2 = this.width; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; 0 <= _ref2 ? _k++ : _k--) {
            _results1.push(this.matrix[i].push({
              "tile": grass,
              "person": '',
              "occupied": false
            }));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    World.prototype.run = function(stop) {
      var running, _that;
      _that = this;
      if (stop === false) {
        return running = setInterval(function() {
          return _that.turn(_that);
        }, this.speed);
      } else {
        return clearInterval(running);
      }
    };

    World.prototype.turn = function(_that) {
      var _this;
      if (_that != null) {
        _this = _that;
      } else {
        _this = this;
      }
      return _this.turnCounter++;
    };

    World.prototype.makeStage = function() {
      var column, i, row, y, _i, _len, _ref, _results;
      this.stage = [];
      _ref = this.matrix;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        this.stage.push([]);
        _results.push((function() {
          var _j, _len1, _results1;
          _results1 = [];
          for (y = _j = 0, _len1 = row.length; _j < _len1; y = ++_j) {
            column = row[y];
            if (column.person instanceof Person) {
              _results1.push(this.stage[i][y] = column.person.printElement());
            } else {
              _results1.push(this.stage[i][y] = column.tile.printElement());
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    World.prototype.update = function() {
      return this.makeStage();
    };

    return World;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.World = World;

}).call(this);
