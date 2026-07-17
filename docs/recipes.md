# Usage Guides

## How to retrieve data reactively from an HTTP resource

The most fundamental interaction with any HTTP API is retrieving data. Broadway handles this by dispatching a `GET` request and emitting the response as an event, rather than returning a synchronous value. 

```coffeescript
# assuming the resource has been resolved via Belmont
resource.subscribe ({ name, value }) ->
  if name == "value"
    # process the response value
    
resource.get()
```

1.  Resolve the HTTP resource using the Belmont registry.
2.  Subscribe to the resource's reactive topic.
3.  Call the `get` method to initiate the asynchronous HTTP request.
4.  Handle the incoming `value` event when the response is successfully received from the server.

## How to submit or update data on a remote server

When creators need to create new records or update existing ones, they must send a payload to the server. Broadway provides the `post` and `put` methods for this purpose, keeping the interaction entirely reactive.

```coffeescript
# assuming the resource has been resolved via Belmont
resource.subscribe ({ name, value }) ->
  if name == "created" or name == "value"
    # process the newly created or updated resource data

resource.put
  id: "123"
  title: "Updated Item"
```

1.  Subscribe to the resource's topic to listen for the `created` or `value` events.
2.  Prepare the data payload representing the new state.
3.  Call the `put` (or `post`) method with the payload to dispatch the request.
4.  Process the results when the corresponding success event is dispatched by Broadway.

## How to automatically resolve and handle nested resources

A complex but common pattern in REST APIs occurs when creating a new child resource within a collection. The server often responds to a `POST` request with a `Location` header pointing to the newly created entity. Broadway's event combinators automatically intercept this header, resolve the new child resource, and publish events to keep the application state synchronized without manual wiring.

```coffeescript
# assuming the parent collection resource has been resolved
collectionResource.subscribe ({ name, locator }) ->
  if name == "created"
    # The locator points to the newly resolved child resource
    # the application can now subscribe to this new locator
    
collectionResource.post
  title: "New Child Item"
```

1.  Subscribe to the parent collection's reactive topic.
2.  Call the `post` method with the new item payload.
3.  When Broadway detects the `Location` header in the response, it automatically resolves the child resource in the background.
4.  Listen for the `created` event on the parent, which includes the `locator` for the newly resolved child resource, allowing the creator to immediately interact with it.

## How to permanently remove a resource

Eventually, creators must remove resources from the server. Broadway provides the `delete` method to execute this action reactively, allowing the application to tear down state precisely when the server confirms removal.

```coffeescript
# assuming the resource has been resolved via Belmont
resource.subscribe ({ name }) ->
  if name == "deleted"
    # perform cleanup after deletion

resource.delete()
```

1.  Subscribe to the resource to listen for the `deleted` event.
2.  Call the `delete` method to initiate the removal request.
3.  Perform necessary clean up operations, such as removing the item from the view, when the `deleted` event is received.
