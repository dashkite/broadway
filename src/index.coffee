import * as Fn from "@dashkite/joy/function"
import Provider from "@dashkite/belmont/provider"
import HTTP from "@dashkite/altair"
import { make, value, wildcard, start } from "./combinators"

class Broadway extends Provider

  get: Fn.pipe [
    -> HTTP.get @locator
    make
    value
    wildcard
    start
  ]

  put: Fn.pipe [
    -> HTTP.put @locator
    make
    value
    wildcard
    start
  ]

  post: Fn.pipe [
    -> HTTP.post @locator
    make
    wildcard
    start
  ]

  delete: Fn.pipe [
    -> HTTP.delete @locator
    make
    wildcard
    start
  ]

export default Broadway