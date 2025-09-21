import EventCoroutine from "@dashkite/reactive/event-coroutine"
import Provider from "@dashkite/belmont/provider"
import HTTP from "@dashkite/altair"

class Broadway extends Provider

  get: ->

    EventCoroutine

      .make HTTP.get @locator
      .bind @

      .when "success", ( event ) ->

        @publish 
          event: "value"
          value: event.response.content

        @publish event

      # process related responses
      .when "authenticate", ->

      # error
      .when "error", ({ error }) ->
        # for now, strip off sublime: prefix
        # see: issue #1
        if /^sublime: /.test error.message        
          @publish name: error.message[9..]

      # by default, pass events through
      .when "*", ( event ) -> @publish event

      .start()

  put: ( value ) ->

  post: ( value ) ->

  delete: ->

export default Broadway