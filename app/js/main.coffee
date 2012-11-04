# Entry point of the application
# Here goes the wireing code
define [
  'cs!js/layout/header'
  'cs!js/model/directory'
  'cs!js/model/person'
  'cs!js/layout/directoryPanel'
], (Header, Directory, Person, DirectoryPanel) ->
  new Header $ "body"
  dir = new Directory
  dp = new DirectoryPanel $("body"), dir 
  dp.draw()
  #Adding some dummy people so that we don't have an empty dir
  dir.addPerson new Person "Justin Bieber", "In his bed", "0 123 456 789", "justin@himse.lf"
  dir.addPerson new Person "Clara Morgan", "In your Bed", "0 987 654 321", "clara@morgan.fr"