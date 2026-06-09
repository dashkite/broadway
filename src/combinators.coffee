import * as Fn from "@dashkite/joy/function"
import * as Val from "@dashkite/joy/value"
import EventCoroutine from "@dashkite/reactive/event-coroutine"
import Scout from "@dashkite/scout"
import Registry from "@dashkite/registry"
import Belmont from "@dashkite/belmont"

Combinators =

  make: ( reactor ) ->
    EventCoroutine
      .make reactor
      .bind @
      .when "authenticate", ->
        application = await Registry.get "application"
        presence = await Registry.get "presence"

        application.navigate name: "connect"
        
        do ->
          for await event from presence.subscribe()
            if event.name == "connect"
              return true
            if event.name == "rejected"
              return false
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
        locator = Scout.decode url.pathname,
            await Scout.discover url.origin
        locator.origin = url.origin

        # publish to child resource (initialization)
        child = await Belmont.resolve locator
        child.publish
          name: "created"
          scope: "resource"
          value: event.response.content

        # publish to parent resource (collection update)
        @publish
          name: "created"
          scope: "resource"
          value: event.response.content
          locator: locator

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
      @publish name: "deleted", scope: "resource"
      @publish event

  wildcard: ( co ) ->
    co.when "*", ( event ) -> 
      @publish event

  start: ( co ) -> co.start()

export default Combinators
