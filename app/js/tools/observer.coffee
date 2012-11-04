#Source : https://gist.github.com/1855639
###
  This module for global Observer
  very simple implementation, but works
  and support method chaining
###
define ->
  class Observer
    ###
    Event binding
    ###
    bind : (event, fn) ->
      @_events ?= {}
      @_events[event] ?= []
      @_events[event].push fn
      @

    ###
    Event unbinding
    CAVEAT! anonymous function cant be unbinded for some reason
    ###
    unbind: (event, fn) ->
      @_events ?= {}
      # must check, last registered event be unbinded as error
      if @_events[event]?.indexOf(fn) >= 0
        @_events[event]?.splice @_events[event].indexOf(fn), 1
      @

    ###
    Event trigger
    ###
    trigger: (event, args...) ->
      @_events ?= {}
      if @_events[event]
        # we are testing callback defined because 
        # it may be undef if it been unbinded at previews scope
        for callback in @_events[event] when callback
            # we are don't want stop ALL callback, just broken
            try 
              callback.apply @, args
            catch err_msg
              console?.error \
              "ERROR: event |#{event}| with args |#{args?.join ', '}| on callback \n #{callback} \n return error |#{err_msg}|"
    @