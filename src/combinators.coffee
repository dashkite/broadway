import * as Fn from "@dashkite/joy/function"
import * as Val from "@dashkite/joy/value"
import EventCoroutine from "@dashkite/reactive/event-coroutine"
import Scout from "@dashkite/scout"

Combinators =

  make: ( reactor ) ->
    EventCoroutine
      .make reactor
      .bind @
      .when "authenticate", ->
      .when "retry", ->

  get: ( co ) ->
    co.when "ok", ( event ) ->
      @publish event
      @publish 
        name: "value"
        scope: "resource"
        value: event.response.content

  post: ( co ) ->
    co.when "created", ( event ) ->
      @publish event
      if ( location = event.response.headers.get "location" )?
        url = new URL location, @locator.origin
        @publish
          name: "created"
          scope: "resource"
          value: event.response.content
          locator: Scout.decode url.pathname,
            await Scout.discover url.origin

  put: ( co ) ->
    co.when "ok", ( event ) ->
      @publish event
      @publish 
        name: "value"
        scope: "resource"
        value: event.response.content
    co.when "created", ( event ) ->
      @publish event
      @publish 
        name: "created"
        scope: "resource"
        value: event.response.content

  delete: ( co ) ->
    co.when "ok, no-content", ( event ) ->
      @publish name: "delete", scope: "resource"
      @publish event

  wildcard: ( co ) ->
    co.when "*", ( event ) -> 
      @publish event

  start: ( co ) -> co.start()

export default Combinators
