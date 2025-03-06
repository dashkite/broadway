import Generic from "@dashkite/generic"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"
import HTTP from "./http"

class Broadway extends Provider

  get: ->
    @publish event for await event from ( HTTP.get @locator )
    return

  put: do ->
 
    ( Generic.make "Broadway.put" )

      .define [( -> true )], ( value ) ->
        # we're optimistically reactive
        @publish { name: "value", value  }
        for await event from ( HTTP.put @locator, value )
          # we already published the value once
          @publish event unless event.name == "value"
          # undo the previous update
          @get() if event.name == "failure"
        return

      .define [ Function ], ( mutator ) ->
        for await event from ( HTTP.get @locator )
          @publish event
          if event.name == "value"
            @put ( await mutator structuredClone event.value )
        return

  post: ( value ) ->
    @publish event for await event from HTTP.post @locator, value
    return

  delete: ->
    @publish event for await event from HTTP.delete @locator
    return

export default Broadway