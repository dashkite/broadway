import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import Resource from "@dashkite/belmont"
import Providers from "@dashkite/belmont/providers"

import $ from "../src"

import configuration from "./configuration"
{ origin } = configuration

Providers.add "https", $

Resources = {}

# No-op caching interface
globalThis.window ?= {}
window.caches =
  open: ( name ) ->
    put: ( url, response ) ->
    delete: ( url ) ->
    match: ( url ) -> undefined

# Email profile
# TODO will need to add real credentials here
import Profile from "@dashkite/profile"
Profile.save email: "test@acme.com"

Generators =
  expected: ( address ) ->
    updates: [
      { address, name: 'My First Site', description: null }
      { address, name: 'Not My First Site' }
    ]
    put: [{ address, name: 'Not My First Site' }]
    get: [{ address, name: 'My First Site', description: null }]

actual =
  updates: []
  put: []
  get: []


do ->

  print await test "Broadway", [

    test "integration test", ->

      Resources.sites = await Resource.resolve { origin, name: "sites" }

      { value: site } = await Resources.sites
        .post name: "My First Site"
        # .when "created", ({ location }) -> console.log { location }
        .resolve "value"

      expected = Generators.expected site.address

      # TODO get locator from created event
      Resources.site = await Resource.resolve { 
        origin
        name: "site"
        bindings:
          site: site.address
      }

      Resources.site
        .observe()
        # .when "update", ({ value }) -> actual.updates.push value
        .when "update", ({ value }) -> actual.updates.push value
        .run()

      await Resources.site
        .get()
        .when "value", ({ value }) -> actual.get.push value
        .run()

      await Resources.site
        .put ( value ) ->
          value.name = "Not My First Site"
          value
        .when "value", ({ value }) -> actual.put.push value
        .run()

      assert.deepEqual expected, actual

  ]

  process.exit if success then 0 else 1
