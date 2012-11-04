# here goes the end to end test (test that all the modules are properly wired)
requirejs = require('requirejs_helper').requirejs
asyncTest = require('requirejs_helper').asyncTest

asyncTest (done) ->
  requirejs [
    'cs!js/main'
  ], ->
    describe "main page", ->
      it "should have a proper header", ->
        expect($(".navbar .brand").text()).toContain "directory"
      
      it "should have a table tag", ->
        expect($("table").length).not.toBe(0)
    done()