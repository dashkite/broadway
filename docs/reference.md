# Reference

## Broadway

The Broadway provider handles HTTP resources. It extends `@dashkite/belmont/provider`.

### get
$get: \to \emptyset$

Initiates an HTTP `GET` request for the resource. Results are published to the topic as events.

### put
$put: value \to \emptyset$

Initiates an HTTP `PUT` request for the resource with the given value as content.

### post
$post: value \to \emptyset$

Initiates an HTTP `POST` request for the resource with the given value as content.

### delete
$delete: \to \emptyset$

Initiates an HTTP `DELETE` request for the resource.
