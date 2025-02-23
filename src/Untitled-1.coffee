
for await event from @
  switch event.name
    when "initialize"
      setUpEventHandlers()
    when "connect"

    when "activate"


Reactors =

  "resource value producer with default": 
    ( specifier ) ->
      for await event from specifier.resource.get()
        switch event.name
          when "value" then yield event
          when "failure"
            switch event.reason
              when "not found"
                yield name: "value", value: specifier.default
              when "authorization"
                # TODO ...
              else
                message event
          else yield event

activate: ->

  events = Reactors[ "resource value producer with default" ]
    resource: site
    default: {}

  for await event from events
    switch event.name
      when "value"
        @gadgets = Gadgets.from event.value
        yield @gadgets

"move gadget": ( id, destination ) ->
  gadget = @gadgets.get id
  gadget.move destination
  for await event from @site.put @gadgets.data
    switch event.name
      # ...
  
