import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"


import Resource from "@dashkite/belmont"
import Providers from "@dashkite/belmont/providers"

import $ from "../src"

import configuration from "./configuration"
{ origin } = configuration

import expected from "./expected"

Providers.add "https", $

Resources = {}
  
do ->

  print await test "Broadway", [

    test "integration test", ->

      Resources.sites = await Resource.resolve { origin, name: "sites" }

      { value: site } = await Resources.sites
        .post name: "My First Site"
        .when "created", ({ location }) -> console.log { location }
        .resolve "value"

      # TODO get locator from created event
      Resources.site = await Resource.resolve { 
        origin
        name: "site"
        bindings:
          site: site.address
      }

      # actual =
      #   updates: []
      #   put: []
      #   get: []

      # Resources.site
      #   .observe()
      #   # .when "update", ({ value }) -> actual.updates.push value
      #   .when "update", ({ value }) -> console.log value
      #   .run()

      { value: site } = await Resources.site
        .get()
        .resolve "value"

      console.log get: site

      # await Resources.site
      #   .put ( value ) ->
      #     value.name = "Not My First Site"
      #     value
      #   # .when "success", -> actual.put.push "hello, world!"
      #   .run()

      # await resource
      #   .get()
      #   # .when "value", ({ value }) -> actual.get.push value
      #   .run()

      # await resource
      #   .put -> "goodbye!"
      #   .run()

      # assert.deepEqual expected, actual
      # console.log actual
      

  ]

  process.exit if success then 0 else 1
