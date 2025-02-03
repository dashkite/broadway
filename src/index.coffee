import Generic from "@dashkite/generic"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"
import HTTP from "@dashkite/altair"

class Errors

  @make: ( name ) ->
    new Error "Broadway: #{ name }"

class Broadway extends Provider

  get: ->
    self = @
    EventReactor.from do ->
      for await event from ( HTTP.bind HTTP.get self.locator )
        if event.when "success"
          yield name: "success"
          value = event.get "response json"
          yield { name: "value", value }
        else if event.when "failure"
          # TODO are there other errors we need to worry about?
          error = event.get "failure error"
          yield { name: "failure", error }
    
  put: do ->
 
    ( Generic.make "Broadway.put" )

      .define [( -> true )], ( value ) ->
        self = @
        EventReactor.from do ->
          # we're optimistically reactive
          self.dispatch { name: "update", value  }
          for await event from ( HTTP.bind HTTP.put self.locator, value )
            if event.when "success"
              yield name: "success"
              value = event.get "response json"
              yield { name: "value", value }
            else if event.when "failure"
              # TODO are there other errors we need to worry about?
              error = event.get "failure error"
              yield { name: "failure", error }
              # undo the previous update
              { value } = await self.get().resolve "value"
              self.dispatch { name: "update", value  }

      .define [ Function ], ( mutator ) ->
        self = @
        EventReactor.from do ->
          { value } = await self.get().resolve "value"
          yield from await self.put ( await mutator value )

  post: ( value ) ->
    self = @
    EventReactor.from do ->
      for await event from ( HTTP.bind HTTP.post self.locator, value )
        if event.when "success"
          if event.when "created"
            # TODO add resource to registry
            # TODO generate lifecycle event for resource
            self.dispatch name: "created", location: event.get "location"
          yield name: "success"
          value = event.get "response json"
          yield { name: "value", value }
        else if event.when "failure"
          # TODO are there other errors we need to worry about?
          error = event.get "failure error"
          yield { name: "failure", error }


export default Broadway