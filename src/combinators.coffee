import EventCoroutine from "@dashkite/reactive/event-coroutine"

make = ( reactor ) ->
  EventCoroutine
    .make reactor
    .bind @
    # process related responses
    .when "authenticate", ->
    # error
    .when "error", ({ error }) ->
      # for now, strip off sublime: prefix
      # see: issue #1
      if /^sublime: /.test error.message        
        @publish name: error.message[9..]

value = ( co ) ->
  co.when "success", ( event ) ->
    @publish 
      event: "value"
      value: event.response.content
    @publish event

wildcard = ( co ) ->
  # by default, pass events through
  co.when "*", ( event ) -> @publish event

start = ( co ) -> co.start()

export { make, value, wildcard, start }