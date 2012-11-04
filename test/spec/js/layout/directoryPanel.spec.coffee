requirejs = require('requirejs_helper').requirejs
asyncTest = require('requirejs_helper').asyncTest

asyncTest (done) ->
  requirejs [
    'cs!js/layout/directoryPanel'
    'cs!js/model/directory'
    'cs!js/model/person'
    ], (DirectoryPanel, Directory, Person) ->

    describe "The directory panel", ->
      dir = new Directory
      dp = new DirectoryPanel $('body'), dir

      dir.addPerson new Person "toto", "localhost", "0666", "to@to.com"
      dir.addPerson new Person "titi", "localhost", "0666", "ti@ta.com"
      
      it "shoud not bug when draw", ->
        dp.draw()
        expect($('table').text()).toContain('ti@ta.com')
    done()
