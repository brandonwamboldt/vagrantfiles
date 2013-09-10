var express = require('express');
var app     = express();

// Express configuration
app.configure(function () {
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.set('view options', { layout: false });

  // Middleware
  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.methodOverride());
  app.use('/assets', express.static(__dirname + '/public'));

  // Router
  app.use(app.router);
});

app.configure('development', function () {
  app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));
});

app.configure('production', function () {
  app.use(express.errorHandler({
    dumpExceptions: false,
    showStack: false
  }));
});

// Routes
app.get('/', function (req, res) {
	res.send('Hello, World!');
});

// Start the ExpressJS web server
var port = process.env.PORT || 80;

app.listen(port, function () {
  console.log('Express is now up and running on port ' + port + ', environment: ' + app.get('env'));
});
