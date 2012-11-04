define ->
  class Observable
    
    observe : (event, obj) ->
      @_observers ?= {}
      @_observers[event] ?= []
      @_observers[event].push obj
      @

    unobserve: (event, obj) ->
      @_observers ?= {}
      # must check, last registered event be unbinded as error
      if @_observers[event]?.indexOf(obj) >= 0
        @_observers[event]?.splice @_observers[event].indexOf(obj), 1
      @

    publish: (event, args...) ->
      @_observers ?= {}
      if @_observers[event]
        # we are testing observer defined because 
        # it may be undef if it been unbinded at previews scope
        for observer in @_observers[event] when observer
            # we are don't want stop ALL observer, just broken
            try 
              observer.trigger event, args
            catch err_msg
              console?.error \
              "ERROR: event |#{event}| with args |#{args?.join ', '}| on observer \n #{observer} \n return error |#{err_msg}|"
    @