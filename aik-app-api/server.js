// Get our dependencies
var express = require('express');
var app = express();
//var mysql = require("mysql");
//var connection = mysql.createConnection({
//  host     : process.env.DB_HOST || 'mysql-test.cxrpknmq0hfi.us-west-2.rds.amazonaws.com',
//  user     : process.env.DB_USER || 'applicationuser',
//  password : process.env.DB_PASS || 'applicationuser',
//  database : process.env.DB_NAME || 'movie_db'
//});

//connection.connect();

//function getMovies(callback) {    
//        connection.query("SELECT * FROM movie_db.movies",
//            function (err, rows) {
//                callback(err, rows); 
//            }
//        );    
//}

//Testing endpoint
app.get('/', function(req, res){
  var response = [{response : 'hello'}, {code : '200'}]
  res.json(response);
})

// Implement the movies API endpoint
app.get('/buycars', function(req, res){
  var vehicles = [
    {title : 'Xerato', release: '2020', score: 8, price: '80.000.000', description : 'Modern Car 1.6CC'},    
    {title : 'Pikanto', release : '2020', score: 6, price: '40.000.000', description : 'Modern Car 1.0CC'},
    {title : 'Rio Zedan', release: '2016', score: 9, price: '30.000.000', description : 'Modern Car 2.0CC'},
    {title : 'Zoluto', release: '2016', score: 9, price: '20.000.000', description : 'Modern Car 3.0CC'},
    {title : 'Stringer', release : '2015', score: 7, price: '10.000.000', description: 'Modern Car 3.0CC'},
    {title : 'Ant-Man', release: '2015', score: 8, price: '70.000.000', description : 'Modern Car 1.0CC'},
    {title : 'Rio Jatchbash', release : '2014', score: 10, price: '50.000.000', description : 'Modern Car 1.0CC'},
  ];

  res.json(vehicles);
});

//app.get('/', function(req, res, next) {   
    //now you can call the get-driver, passing a callback function
//    getMovies(function (err, moviesResult){ 
       //you might want to do something is err is not null...      
//       res.json(moviesResult);

//    });
//});

// Implement the reviewers API endpoint
app.get('/vehicles', function(req, res){
  var vehicles = [
    {name : 'Xerato', description : 'Modern Car 1.6CC', avatar: 'https://www.kia.com/content/dam/kwcms/co/es/images/shoppingtool/Cerato-Showroom.png'},
    {name: 'Pikanto', description : 'Modern Car 1.6CC', avatar: 'https://www.kia.com/content/dam/kwcms/co/es/images/showroom/PicantoNew/kia-co-picanto-ja.png'},
    {name: 'Rio zedan', description : 'Modern Car 1.6CC', avatar: 'https://www.kia.com/content/dam/kwcms/gt/en/images/vehicles/gnb/kia_rio_sc_4dr_17my.png'},
    {name: 'Zoluto', description : 'Modern Car 1.6CC', avatar: 'https://www.kia.com/content/dam/kwcms/gt/en/images/vehicles/gnb/kia_ab_19my.png'},
    {name: 'Stringer', description: 'Modern Car 1.6CC', avatar: 'https://www.kia.com/content/dam/kwcms/co/es/images/showroom/stinger/kia-stinger.png'},
    {name: 'Ant-man', description: 'Modern Car 1.6CC', avatar : 'https://vignette.wikia.nocookie.net/marvelcinematicuniverse/images/4/4b/Luis%27_Van_%28Quantum_Tunnel%29.png/revision/latest/scale-to-width-down/310?cb=20181002134025'},
    {name: 'Rioc Jatchbash', description : 'Modern Car 1.6CC', avatar : 'https://www.kia.com/content/dam/kwcms/gt/en/images/vehicles/gnb/kia-rio-sc.png'}
  ];

  res.json(vehicles);
});

// Implement the publications API endpoint
app.get('/support', function(req, res){
  var support = [
    {name : 'Mechanics Appointments', avatar: 'glyphicon-eye-open'},
    {name : 'Post-sale service', avatar: 'glyphicon-fire'},
    {name : 'Guarantee', avatar: 'glyphicon-time'},
    {name : 'Online manual', avatar: 'glyphicon-record'},
    {name : 'New AIK', avatar: 'glyphicon-heart-empty'},
    {name : 'safety campaigns', avatar : 'glyphicon-globe'}
  ];

  res.json(support);
});

// Implement the pending reviews API endpoint
app.get('/pending', function(req, res){
  var pending = [
    {title : 'Superman: Homecoming', release: '2017', score: 10, reviewer: 'Chris Harris', publication: 'International Movie Critic'},
    {title : 'Wonder Woman', release: '2017', score: 8, reviewer: 'Martin Thomas', publication : 'TheOne'},
    {title : 'Doctor Strange', release : '2016', score: 7, reviewer: 'Anthony Miller', publication : 'ComicBookHero.com'}
  ];

  res.json(pending);
});
console.log("server listening through port: "+process.env.PORT);
// Launch our API Server and have it listen on port 3000.
app.listen(process.env.PORT || 3000);
module.exports = app;
