## Intro

This code is a working example of an efficient js workflow. To experiment with the workflow, a simple web directory has been developed as an example.

This example relies on many existing lib:

* coffeescript
* jasmine
* requirejs
* bootstrap
* jasmine-node

And more...

I personally recommend using sublime text 2 with the [coffeScirpt plugin](https://github.com/Xavura/CoffeeScript-Sublime-Plugin). When I code, I usually split vertically my sublime window so that I can see the code along with the related tests.


## Parti Pris

This workflow has been developed with 2 main objectives in mind:
* Testability
* Light constraints

So only a few simple, rock solid, frameworks are used.

To ease testing, a dependency injection model has been chosen. The key principle is that every part of the code is properly sharded into modules. Each module, defined as a coffeescript class, ask for all needed modules directly in its constructor. This way, it is very easy to test each module independently, and to mock and inject constraining modules. (More details at http://www.youtube.com/watch?v=wEhu57pih5w&feature=relmfu )

## How it works?

* The entry point of the application can be found at `app/js/main.coffee`. This code can be seen as the wiring code: It builds all the modules and wires them together.
* The modules are split into 2 main categories:
  * Model: Code that contains the working logic, data, etc.
  * Layout: Code that is responsible for displaying the Model (here goes the DOM stuff).

Some scripts are also provided as part of the workflow:

### dev.js

The dev.js script handles the development workflow. This script is inspired from the guard gem: It watches file saves and runs test appropriately.
* If a source file is saved (say app/js/model/toto.coffee), all tests in the related test branch are executed automatically (say test/spec/js/model/*).
* If a test is saved, only this test is executed. This enables to launch any test very quickly, directly from the text editor.

Launch dev env: `node scripts/dev`

### build.js

This script enables to build all the coffee-script code, to concatenate it into one file, and to optimize it. The resulting code can be found in the `build` directory. The code can be directly used in production servers.

Launch build: `node scripts/build`

# Hands on: Guided scenario

This tutorial enables to understand how the example works by extending it.

## Scenario

The present directory is very simple and misses one essential feature: The possibility to add contacts to our directory.

We are going to implement this feature while making most of the dev workflow.

## Install

If you don't have [node.js](http://nodejs.org/) on your machine (how is that even possible? :) ) install it.

Clone this git repo `git clone ???`.

Go to the project dir `cd js-de-env`

install npm dependencies `npm install`

## Start the dev workflow

Let's start the dev environment `node scripts/dev`
Keep the terminal somewhere visible so that you can see the results of the tests.


## Designing tests

Test time is the right time to design your features: Your mind is spec oriented, not yet confused with implementation details.

The module we want to create must be like a form that the user will fill. This form will be attached to the DOM by an html tag. Also, this module will take a `Directory` object in order to modify it. Here we have a pretty clear picture of our class constructor: It will take 2 arguments - a DOM tag and a directory.

Our class will need only one method that will be triggered by clicking the add button. This method will act on the directory to add a person to it.


## Writing tests

For this scenario, we are working on the UI, so we will put our code (as well as our tests) in the `layout` section.

Let's create the file: `test\spec\js\layout\contactAdder.spec.coffee`

At this time, a new test file should be detected in the console, but there is not test in it. It is time to write some tests:

In `test\spec\js\layout\contactAdder.spec.coffee`:
```
# Those modules are necessary to test requirejs modules
requirejs = require('requirejs_helper').requirejs
asyncTest = require('requirejs_helper').asyncTest

# Helper method to fill the form using jquery to simulate what a user would do
# Remark: This helper can be put in test/node_modules/your_custom_helper.js and then used by require('your_custom_herlper')
fillAddContact = (name, address, phone, email) ->
  $('#new_contact_name').val name
  $('#new_contact_address').val address
  $('#new_contact_phone').val phone
  $('#new_contact_email').val email

# Since v2.1, RequireJS is fully asynchronous. Thus it is necessary to use asynchronous testing by calling done() once testing is finished.
asyncTest (done) ->
  # We are requiering some dependencies 
  requirejs [
    'cs!js/layout/contactAdder'
    'cs!js/model/directory'
  ], (ContactAdder, Directory) ->

    describe 'Contact adder', ->

      dir = new Directory
      # Instatiate the ContactAdder and attach it to the body tag
      contactAdder = new ContactAdder $("body"), dir

      it 'should have a "new contact" form to fill', ->
        expect($('#new_contact_name').length).toBe(1)
        expect($('#new_contact_address').length).toBe(1)
        expect($('#new_contact_phone').length).toBe(1)
        expect($('#new_contact_email').length).toBe(1)
        expect($('#new_contact_btn').length).toBe(1)
      
      it 'should enable to fill & add a contact', ->
        n = dir.getContent().length
        fillAddContact "toto", "localhost", "01234", "to@to.ti"
        $('#new_contact_btn').click()
        expect(dir.getContent().length).toBe(n + 1)

    done()
```

Note that we should add also a end to end test (in `test/e2e`) to make sure that the ContactAdder` is well integrated to the application: The point of unit tests is to test each module in isolation, without having to build to whole application for every test.

### Writing code

The error flow provided by the tests will guide us through the implementation of the feature.

First, the error says that there is no `layout/contactAdder.coffee`

`Error: ENOENT, no such file or directory '[...]/app/js/layout/contactAdder.coffee'`

Let's create this file.

Then we've got a new error: 
```
  1) encountered a declaration exception
   Message:
     TypeError: undefined is not a function
   Stacktrace:
     TypeError: undefined is not a function
    at null.<anonymous> (/[...]/test/spec/js/layout/contactAdder.spec.coffee:20:24)
    at jasmine.Env.describe (/[...]/node_modules/jasmine-node/lib/jasmine-node/jasmine-2.0.0.rc1.js:791:21)
    at describe (/[...]/node_modules/jasmine-node/lib/jasmine-node/jasmine-2.0.0.rc1.js:575:27)
    at /[...]/test/spec/js/layout/contactAdder.spec.coffee:17:7
```
 It says in substance that the object line 17 is undefined. This is because we don't have any RequireJS module in the file. Let's create one:

In app/js/layout/contactAdder.coffee
 ```
define ->
  class ContactAdder
 ```

Now we've got a lot of new errors:
```
  1) should have a "new contact" form to fill
   Message:
     Expected 0 to be 1.
   Stacktrace:
     Error: Expected 0 to be 1.
```

This is because we don't have attached any element tag to the DOM. Let's implement the constructor accordingly.

In app/js/layout/contactAdder.coffee
 ```
define ->
  class ContactAdder
    constructor: (tag, @dir) ->
      table = $ '<table class="table table-striped"></table>'
      table.appendTo tag
      table.append '
      <form class="form-inline">
        <input id="new_contact_name" type="text" placeholder="Name">
        <input id="new_contact_address" type="text" placeholder="Address">
        <input id="new_contact_phone" type="text" placeholder="Phone">
        <input id="new_contact_email" type="text" placeholder="Email">
        <button id="new_contact_btn" type="button" class="btn btn-primary">Add Contact</button>
      </form>
      '
 ```

 Now we have the following error:
 ```
  1) should enable to fill & add a contact
   Message:
     Expected 0 to be 1.
   Stacktrace:
     Error: Expected 0 to be 1.
    at new jasmine.ExpectationResult (/[...]/node_modules/jasmine-node/lib/jasmine-node/jasmine-2.0.0.rc1.js:102:32)
    at null.toBe (/[...]/node_modules/jasmine-node/lib/jasmine-node/jasmine-2.0.0.rc1.js:1171:29)
    at null.<anonymous> (/[...]/test/spec/js/layout/contactAdder.spec.coffee:33:50)
 ```

This error implies that the number of contacts in the directory was not incremented. So no contact was added to the directory. Let's fix that:

In app/js/layout/contactAdder.coffee
```
define ['cs!js/model/person'], (Person)->
  class ContactAdder
    constructor: (tag, @dir) ->
      table = $ '<table class="table table-striped"></table>'
      table.appendTo tag
      table.append '
      <form class="form-inline">
        <input id="new_contact_name" type="text" placeholder="Name">
        <input id="new_contact_address" type="text" placeholder="Address">
        <input id="new_contact_phone" type="text" placeholder="Phone">
        <input id="new_contact_email" type="text" placeholder="Email">
        <button id="new_contact_btn" type="button" class="btn btn-primary">Add Contact</button>
      </form>
      '
      $("#new_contact_btn").click => this.addContact $("#new_contact_name").val(),
                                                     $("#new_contact_address").val(),
                                                     $("#new_contact_phone").val(),
                                                     $("#new_contact_email").val()

    addContact: (name, address, phone, email) ->
      @dir.addPerson new Person name, address, phone, email

```

All tests should pass now. But we are not completely done yet: We need to add out brand new contactAdder to app/js/main.coffee:

In app/js/main.coffee
```
# Entry point of the application
# Here goes the wireing code
define [
  'cs!js/layout/header'
  'cs!js/model/directory'
  'cs!js/model/person'
  'cs!js/layout/directoryPanel'
  'cs!js/layout/contactAdder'
], (Header, Directory, Person, DirectoryPanel, ContactAdder) ->
  new Header $ "body"
  dir = new Directory
  dp = new DirectoryPanel $("body"), dir 
  dp.draw()
  #Adding some dummy people so that we don't have an empty dir
  dir.addPerson new Person "Justin Bieber", "In his bed", "0 123 456 789", "justin@himse.lf"
  dir.addPerson new Person "Clara Morgan", "In your Bed", "0 987 654 321", "clara@morgan.fr"
  ca = new ContactAdder $("body"), dir
```
Now we can have a good confidence that our feature works. You can browse app/index.html to make sure :) (Make sure to have an http server. You can use `python -m SimpleHTTPServer` and then browse http://localhost:8000/app/ )

### Publishing result

Now we are ready to publish a new version of the website. Let's build the website:

`node scripts/build`

The content of the build directory can be published directly to your website

