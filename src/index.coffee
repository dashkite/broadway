import Generic from "@dashkite/generic"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"
import HTTP from "./http"

class Broadway extends Provider

  get: ->
    @publish event for await event from ( HTTP.get @locator )
    return

  put: ( value ) ->
    # we're optimistically reactive
    @publish { name: "value", value  }
    for await event from ( HTTP.put @locator, value )
      # we already published the value once
      @publish event unless event.name == "value"
      # undo the previous update
      @get() if event.name == "failure"
    return

  post: ( value ) ->
    @publish event for await event from HTTP.post @locator, value
    return

  delete: ->
    @publish event for await event from HTTP.delete @locator
    return

export default Broadway