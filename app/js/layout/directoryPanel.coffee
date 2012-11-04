define [
  'cs!js/tools/observer'
  'underscore'
  ], (Observer, _)->
  class DirectoryPanel extends Observer
    constructor: (@tag, @dir) ->
      @table = $('<table class="table table-striped"></table>')
      @table.appendTo(@tag);
      this.flushTable()
      this.draw()
      @dir.observe "onDirectoryChange", this
      @bind "onDirectoryChange", @draw

    flushTable: ()->
      @table.empty()
      $('<tr>
        <th>Name</th>
        <th>Address</th>
        <th>Phone Number</th>
        <th>Email</th>
        </tr>').appendTo @table

    draw: () ->
      this.flushTable()
      _.each @dir.getContent(), (contact) =>
        @table.append contact.toHtml()
