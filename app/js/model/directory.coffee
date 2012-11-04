define [
  'cs!js/tools/observable'
  'cs!js/model/person'
], (Observable, Person) ->
  class Directory extends Observable
    constructor: ->
      @persons = []

    getContent: ->
      out = person for person in @persons

    addPerson: (person) ->
      if person not instanceof Person
        throw "Cannot add smth else than a Person to the directory"
      @persons.push person
      @publish "onDirectoryChange"

    removePerson: (i) ->
      @persons = @persons.splice i, i
      @publish "onDirectoryChange"