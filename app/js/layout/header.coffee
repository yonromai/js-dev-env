define ->
  class Header
    constructor: (tag) ->
      tag.html(
        '<div class="navbar navbar-inverse navbar-fixed-top">
          <div class="navbar-inner">
            <div class="container">
              <a class="brand" href="#">Awesome directory</a>
            </div>
          </div>
        </div>')