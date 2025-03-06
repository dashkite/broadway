import Altair from "@dashkite/altair"

HTTP =

  get: ( locator ) ->
    for await event from ( Altair.bind Altair.get locator )
      if event.when "success"
        yield name: "success"
        value = event.get "response json"
        yield { name: "value", value }
      else if event.when "failure"
        # TODO are there other errors we need to worry about?
        error = event.get "failure error"
        yield { name: "failure", error }
    return

  put: ( locator, _value ) ->
    for await event from ( Altair.bind Altair.put locator, _value )
      if event.when "success"
        yield name: "success"
        value = event.get "response json"
        yield { name: "value", value }
      else if event.when "failure"
        # TODO are there other errors we need to worry about?
        error = event.get "failure error"
        yield { name: "failure", error }
    return

  delete: ( locator ) ->
    for await event from ( Altair.bind Altair.delete locator )
      if event.when "success"
        yield name: "success"
      else if event.when "failure"
        # TODO are there other errors we need to worry about?
        error = event.get "failure error"
        yield { name: "failure", error }
    return

  post: ( locator, _value ) ->
    for await event from ( Altair.bind Altair.post locator, _value )
      if event.when "success"
        if event.when "created"
          # TODO add resource to registry
          # TODO generate lifecycle event for resource
          yield name: "created", location: event.get "location"
        yield name: "success"
        value = event.get "response json"
        yield { name: "value", value }
      else if event.when "failure"
        # TODO are there other errors we need to worry about?
        error = event.get "failure error"
        yield { name: "failure", error }
    return

export default HTTP