requirejs = require('requirejs_helper').requirejs
asyncTest = require('requirejs_helper').asyncTest

asyncTest (done) ->
  requirejs ['cs!js/model/directory', 'cs!js/model/person'], (Directory, Person) ->
    describe "A Directory", ->
      
      it "should be empty at start", ->
        dir = new Directory
        expect(dir.getContent().length).toBe(0)

      it "should enable to add a person", ->
        dir = new Directory
        dir.addPerson new Person "toto", "localhost", "0666", "to@to.com"
        expect(dir.getContent().length).toBe(1)

      it "should enable to remove a person", ->
        dir = new Directory
        dir.addPerson new Person "toto", "localhost", "0666", "to@to.com"
        dir.removePerson 0
        expect(dir.getContent().length).toBe(0)

      it "should content the right number of contacts", ->
        dir = new Directory
        dir.addPerson new Person "toto", "localhost", "0666", "to@to.com"
        dir.addPerson new Person "toto", "localhost", "0666", "to@to.com"
        dir.addPerson new Person "toto", "localhost", "0666", "to@to.com"
        expect(dir.getContent().length).toBe(3)

    done()
