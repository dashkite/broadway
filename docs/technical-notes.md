# Technical Notes

### RMVC+R Architecture

Broadway is designed as a foundational component for the RMVC+R (Reactive Model-View-Controller + Resources) architecture within the DashKite ecosystem. The RMVC+R pattern treats an entire application as a system of interacting event streams and logical resources. Within this paradigm, Broadway serves as the critical layer for managing remote HTTP data, ensuring that external network interactions align with the overarching reactive design pattern.

You can learn more about the foundational concepts behind this architecture on [Wikipedia: Model-view-controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) and [Wikipedia: Reactive programming](https://en.wikipedia.org/wiki/Reactive_programming).

### Reactive Resources

In the DashKite ecosystem, data interfaces are abstracted as **Reactive Resources**. Instead of executing traditional synchronous operations or awaiting direct promise resolutions, resources act as asynchronous event reactors. When a developer triggers an operation—such as `put` or `get`—the resource produces a stream of reactive events rather than a direct return value.

Broadway implements this concept specifically for HTTP APIs. When a request is initiated, Broadway translates the standard RESTful HTTP responses into reactive events (such as `value` or `created`). These events are then published to the resource's topic. This decouples request initiation from response handling, enabling applications to be highly concurrent and loosely coupled.

### Belmont Provider Integration

Broadway operates as a concrete resource provider for **Belmont**. Belmont implements the core wiring for the Reactive Resource Model, acting as a high-level abstraction layer that maps logical resource locators to specific transport protocols.

By registering Broadway as the provider for the `http` and `https` protocols, developers instruct Belmont to delegate all HTTP-based resource operations to Broadway. Belmont manages a registry of these instantiated providers and uses Sky APIs to resolve abstract endpoint spaces into concrete URLs. This allows developers to interact with complex HTTP network resources purely through logical names and reactive subscriptions.

### Event Combinators and Workflows

Under the hood, Broadway utilizes event combinators to automatically manage complex HTTP workflows, such as authentication and automatic retries. For instance, when a `POST` request results in the creation of a resource and the server returns a `Location` header, Broadway automatically resolves the new nested resource. It then publishes a `created` event on both the child resource and the parent collection. This ensures strict state consistency across the application without requiring explicit manual wiring from the creator.
