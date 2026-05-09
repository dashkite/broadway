import "@dashkite/altair/install"
import assert from "@dashkite/assert"
import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"

import * as Val from "@dashkite/joy/value"

import Providers from "@dashkite/belmont/providers"
import Resource from "@dashkite/belmont"
import conformance from "@dashkite/belmont/test/conformance"

import Broadway from "../src"
import configuration from "./configuration"
{ origin } = configuration

import Servers from "./server"

# Register Broadway for tests
Providers.add "https", Broadway
Providers.add "http", Broadway

factory =

  existing: ->
    resource: await Resource.resolve {
        origin
        name: "post"
        bindings: { address: "123" }
      }

  missing: ->
    resource: await Resource.resolve {
        origin
        name: "post"
        bindings: { address: "missing" }
      }

  creatable: ->
    resource: await Resource.resolve { 
        origin
        name: "posts"
        bindings: {} 
      }
    data: { title: "New Post", body: "I'm a teapot" }

  unsupported: ->
    resource: await Resource.resolve {
        origin
        name: "post"
        bindings: { address: "123" }
      }
    method: "post"

do ->

  await Servers.start()

  print await test "Broadway", [
    conformance factory
  ]

  await Servers.stop()
