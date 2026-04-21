# Broadway

*Chicago System HTTP Provider*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Purpose

Broadway is an HTTP resource provider for Belmont. It uses `@dashkite/altair` to perform HTTP operations and publishes the results as reactive events.

## Installation

Use your favorite package manager to install `@dashkite/broadway`.

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

- [Reference](docs/reference.md)

## Status

Not suitable for production use. Please report bugs and feature requests via the issue tracker.
