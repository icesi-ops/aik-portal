#!/usr/bin/env node

// Declare our dependencies
var express = require('express');
var request = require('superagent');
var backendHost = process.env.BACK_HOST || 'localhost';
// Create our express app
var app = express();

// Set the view engine to use EJS as well as set the default views directory
app.set('view engine', 'ejs');
app.set('views', __dirname + '/public/views/');

// This tells Express out of which directory to serve static assets like CSS and images
app.use(express.static(__dirname + '/public'));



// The homepage route of our application does not interface with the AIK API and is always accessible. We won’t use the getAccessToken middleware here. We’ll simply render the index.ejs view.
app.get('/', function(req, res){
  res.render('index');
})

app.get('/buycars', function(req, res){
  request
    .get('http://'+backendHost+':3000/buycars')
    .end(function(err, data) {
      if(data.status == 403){
        res.send(403, '403 Forbidden');
      } else {
        var buy = data.body;
        res.render('buycars', { buy: buy} );
      }
    })
})

app.get('/vehicles', function(req, res){
  request
    .get('http://'+backendHost+':3000/vehicles')
    .set('Authorization', 'Bearer ' + req.access_token)
    .end(function(err, data) {
      if(data.status == 403){
        res.send(403, '403 Forbidden');
      } else {
        var vehicles = data.body;
        res.render('vehicles', {vehicles : vehicles});
      }
    })
})

app.get('/support', function(req, res){
  request
    .get('http://'+backendHost+':3000/support')
    .end(function(err, data) {
      if(data.status == 403){
        res.send(403, '403 Forbidden');
      } else {
        var support = data.body;
        res.render('support', {support : support});
      }
    })
})


app.get('/experience', function(req, res){
  request
    .get('http://'+backendHost+':3000/experience')
    .end(function(err, data) {
      if(data.status == 403){
        res.send(403, '403 Forbidden');
      }else{
        var experience = data.body;
        res.render('experience', {experience : experience});
      }
    })
})

module.exports = app.listen(3030);
