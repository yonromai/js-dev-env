define ->
  class Person
    constructor: (@name, @addr, @phone, @email) ->
    toString: () ->
      "#{@name} <#{@email}>" 
    toHtml: () ->
      "<tr>
      <td>#{@name}</td>
      <td>#{@addr}</td>
      <td>#{@phone}</td>
      <td>#{@email}</td>
      </tr>"