# Reference

This document details the public API for the Broadway HTTP resource provider.

## Reactive Provider Concepts

Broadway is a reactive resource provider designed for the RMVC+R architecture. This means that invoking methods on a Broadway resource does not return synchronous values or promises representing the immediate HTTP response. Instead, operations like `get` and `post` dispatch requests via `@dashkite/altair` and publish the subsequent HTTP responses as events (e.g., `value`, `created`, `deleted`) on the resource's reactive topic. 

Many methods accept a `specifier` object. This argument acts as a configuration payload that is spread into the underlying Altair HTTP request, allowing creators to provide custom headers, query parameters, or specific execution options without altering the primary method signature.

## Broadway

The `Broadway` class extends `@dashkite/belmont/provider` to map abstract resource operations to physical HTTP requests.

### get

$get: specifier \to \emptyset$

Initiates an HTTP `GET` request to retrieve the state of the resource. As a reactive operation, this method returns nothing (`undefined`). When the server responds successfully, Broadway publishes a `value` event containing the response content to the resource's topic. The optional `specifier` object allows creators to pass query parameters or custom headers down to the Altair HTTP client.

<example>
This illustrates initiating a GET request on a resource.
```coffeescript
assert.deepEqual undefined, resource.get()
```
</example>

### post

$post: data, specifier \to \emptyset$

Initiates an HTTP `POST` request, submitting the provided `data` payload to the resource. This is typically used to create a new child resource within a collection. The `data` argument represents the serializable state being submitted. Upon successful creation, a `created` event is published. Furthermore, if the server responds with a `Location` header, Broadway's event combinators will automatically resolve the newly created child resource and publish events accordingly. The `specifier` object can be used to customize the Altair request.

<example>
This illustrates initiating a POST request with a payload.
```coffeescript
assert.deepEqual undefined, resource.post { title: "New Document" }
```
</example>

### put

$put: data, specifier \to \emptyset$

Initiates an HTTP `PUT` request to entirely replace or update the state of the resource with the provided `data` payload. When the operation completes, Broadway publishes either a `value` or `created` event depending on whether the server updated an existing entity or created a new one. The `data` argument represents the new state for the resource, and the `specifier` object enables further customization of the Altair request.

<example>
This illustrates initiating a PUT request to update a resource.
```coffeescript
assert.deepEqual undefined, resource.put { title: "Updated Document", active: true }
```
</example>

### delete

$delete: specifier \to \emptyset$

Initiates an HTTP `DELETE` request to permanently remove the resource from the remote server. Upon successful removal, Broadway publishes a `deleted` event to the resource's topic, allowing views and controllers to reactively clean up their state. The `specifier` object allows creators to configure the underlying Altair request, such as passing specific authentication headers if required.

<example>
This illustrates initiating a DELETE request on a resource.
```coffeescript
assert.deepEqual undefined, resource.delete()
```
</example>
