var exec = require('child_process').exec;
var sys = require('sys');
var clc = require('cli-color');
var file = require('file');
var path = require('path');
var fs = require('fs');
var _ = require("underscore");


var err = clc.red.bold;
var notice = clc.yellow;

function puts(error, stdout, stderr) {
 if(error)
  console.log(err(error));
 sys.puts(stdout)
 if(!error)
  next();
}

startsWith = function (str1, str2){
    return str1.indexOf(str2) == 0;
  };

function recursiveClean(dirPath){
  if(fs.readdirSync(dirPath).length == 0){
    fs.rmdirSync(dirPath);
    recursiveClean(path.dirname(dirPath));
  }
}

function rmUseless(){

  toKeep = [
  path.join("build","css"),
  path.join("build","img"),
  path.join("build","index.html"),
  path.join("build","js","start.js"),
  path.join("build","lib","require-jquery.js")
  ];

  file.walkSync(path.join("__dirname","..","build"), function(dirPath, dirs, files){
    _.each(_.flatten(files), function(file){
      if(!_.any(toKeep, function(f){ return startsWith(path.join(dirPath,file), f)})){
        fs.unlinkSync(path.join(dirPath,file));
        console.log("Removing " + file);
      }
    });
    recursiveClean(dirPath);
  });
}

function next(){
  console.log("Cleaning build files.");
  rmUseless();
  console.log("Cleaning done.");
}

console.log("Building application...");
exec("node node_modules/requirejs/bin/r.js -o scripts/app.build.js", puts);


