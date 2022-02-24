var express = require('express');
const Parse = require('parse/node');
var app = express();
// var api = require("./NTapi");
//setting middleware
app.use(express.static("./")); //Serves resources from public folder
 
var server = app.listen(5050);
console.log("Start listen port 5050!!!")