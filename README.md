# Broadway

*Chicago System HTTP Provider*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Broadway is an HTTP resource provider for Belmont. It uses `@dashkite/altair` to perform HTTP operations and publishes the results as reactive events.

## Features

- Translates standard HTTP methods (`GET`, `POST`, `PUT`, `DELETE`) into HTTP requests.
- Integrates directly with `@dashkite/altair` for execution.
- Emits reactive events based on HTTP responses, allowing creators to subscribe to resource updates.
- Supports handling complex workflows like authentication and automatic retry via event combinators.
- Resolves nested resources via `Location` headers after resource creation.

## Installation

```bash
pnpm install @dashkite/broadway
```

## Usage

```coffee
import Providers from "@dashkite/belmont/providers"
import Broadway from "@dashkite/broadway"
import Resource from "@dashkite/belmont"

# Register Broadway for http and https
Providers.add "http", Broadway
Providers.add "https", Broadway

# Resolve and use an HTTP resource
resource = await Resource.resolve
  origin: "https://api.example.com"
  name: "profile"
  bindings: { id: "123" }

resource.subscribe ({ name, value }) ->
  if name == "value"
    console.log "Profile:", value

resource.get()
```

## Other Resources

- [Usage Guides](docs/recipes.md)
- [Reference](docs/reference.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)

## Status

Not suitable for production use. Please report bugs and feature requests via the issue tracker.
