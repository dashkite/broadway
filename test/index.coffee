import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import $ from "../src"

import expected from "./expected"

import Resource from "@dashkite/belmont"
import Providers from "@dashkite/belmont/providers"

Providers.add "https", $
  
do ->

  print await test "Broadway", [

    test "integration test", ->

      # TODO use HTTP URL
      resource = Resource.make "local:/components/add-site"

      actual =
        updates: []
        put: []
        get: []


      resource
        .observe()
        .when "update", ({ value }) -> actual.updates.push value
        .run()

      await resource
        .put "hello, world"
        .when "success", -> actual.put.push "hello, world!"
        .run()

      await resource
        .get()
        .when "value", ({ value }) -> actual.get.push value
        .run()

      await resource
        .put -> "goodbye!"
        .run()

      assert.deepEqual expected, actual
      

  ]

  process.exit if success then 0 else 1
