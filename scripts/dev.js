var path = require("path");
var _ = require("underscore");
var exec = require('child_process').exec;
var sys = require('sys');
var watchr = require('watchr');
var clc = require('cli-color');
var fs = require("fs");

var err = clc.red.bold;
var notice = clc.yellow;
var jasmineNodePath = path.join('node_modules', 'jasmine-node', 'bin', 'jasmine-node');

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

function startsWith(str, suffix){
  return str.indexOf(suffix) == 0;
};

function puts(error, stdout, stderr) {
 if(error)
  console.log(err(error));
 sys.puts(stdout) 
}

var extFilter = function(file, exts){
  var found = false;
  _.each(exts, function(ext){
    if(endsWith(path.basename(file),ext))
      found = true;
  });
  return found;
}

// Watchers
var sourceWatcher = function(f){
  console.log(notice("Saved", path.relative('.',f)));
  var p = path.normalize(f).split(path.sep);
  var i = _.indexOf(p, 'app');
  var testPath = _.union(_.first(p,i),['test','spec'], p.slice(i+1,p.length - 1))
                  .join(path.sep);
  fs.exists(testPath, function(exists){
    if(exists){
      console.log(notice("Running test in:", path.relative('.',testPath)));
      exec(jasmineNodePath + " --coffee  " + testPath, puts);
    } else {
      console.log(notice("No test in:", path.relative('.',testPath)));
    }
  });
  
}

var testWatcher = function(f){
  console.log(notice("Saved", path.relative('.',f)));
  console.log(notice("Running this test"));
  exec(jasmineNodePath + " --coffee  " + f, puts);
}


// Watch a directory or file
watchr.watch({
    path: __dirname + '/../',
    listener: function(eventName,f,fileCurrentStat,filePreviousStat){
      if(eventName !== "unlink"){ 
        if(startsWith(f, path.resolve(__dirname + '/../app/js/')) && 
           extFilter(f,['js', 'coffee'])){
          sourceWatcher(f);
        } else if(startsWith(f, path.resolve(__dirname + '/../test/')) && 
           extFilter(f,['spec.js', 'spec.coffee'])){
          testWatcher(f);
        }
      }
    },
    next: function(err,watcher){
        if (err)  throw err;
        console.log(notice('watching setup successfully'));
    }
});
