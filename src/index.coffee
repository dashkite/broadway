import Generic from "@dashkite/generic"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Errors

  @make: ( name ) ->
    new Error "Halstead: #{ name }"

class Broadway extends Provider

  get: ->
    self = @
    EventReactor.from do ->

  put: do ->
 
    ( Generic.make "Halstead.put" )

      .define [( -> true )], ( value ) ->
        self = @
        EventReactor.from do ->

      .define [ Function ], ( mutator ) ->
        self = @
        # TODO obtain value
        value = undefined
        EventReactor.from do ->
          yield from await self.put ( await mutator value )

export default Broadway