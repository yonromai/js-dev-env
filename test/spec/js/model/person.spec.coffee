requirejs = require('requirejs_helper').requirejs
asyncTest = require('requirejs_helper').asyncTest

asyncTest (done) ->
  requirejs ['cs!js/model/person'], (Person) ->
    describe "A Person", ->
      person = new Person "toto", "localhost", "0666", "to@to.com"

      it "has a working toString method", ->
        expect(person.toString()).toBe("toto <to@to.com>")
    done()