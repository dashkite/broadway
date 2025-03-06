import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import * as Val from "@dashkite/joy/value"

import Resource from "@dashkite/belmont"

import configuration from "./configuration"
{ origin } = configuration

import "./setup"

do ->

  print await test "Broadway", [

    test "integration test", ->

      Resources = {}
      Subscriptions = {}
      Result =
        expected: ( address ) ->
          [
            { address, name: 'My First Site', description: null }
            { address, name: 'Not My First Site', description: null }
          ]

      actual = []

      site = undefined

      Resources.sites = await Resource.resolve { origin, name: "sites" }
      Subscriptions.sites = Resources.sites.subscribe()
      do ->
        for await event from Subscriptions.sites
          switch event.name
            when "value" then site = event.value
        return

      Resources.sites.post name: "My First Site"

      await assert.expect -> site?

      Resources.site = await Resource.resolve { 
        origin
        name: "site"
        bindings:
          site: site.address
      }
      Subscriptions.site = Resources.site.subscribe()

      do ->
        for await event from Subscriptions.site
          switch event.name
            when "value" then actual.push event.value
        return

      Resources.site.put ( value ) ->
        value.name = "Not My First Site"
        value
        
      expected = Result.expected site.address
      await assert.expect -> 
        Val.equal expected, actual

  ]

  process.exit if success then 0 else 1
