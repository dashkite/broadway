import * as Fn from "@dashkite/joy/function"
import Provider from "@dashkite/belmont/provider"
import Altair from "@dashkite/altair"
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

import C from "./combinators"

# Configuration for Altair
HTTP =
  Altair
    .make()
    .use Sublime.make [ sky ]

class Broadway extends Provider

  get: Fn.pipe [
    ( specifier ) ->
      HTTP.get { resource: @locator, specifier... }
    C.make
    C.get
    C.wildcard
    C.start
  ]

  post: Fn.pipe [
    ( data, specifier ) ->
      HTTP.post { resource: @locator, data, specifier... }
    C.make
    C.post
    C.wildcard
    C.start
  ]

  put: Fn.pipe [
    ( data, specifier ) ->
      HTTP.put { resource: @locator, data, specifier... }
    C.make
    C.put
    C.wildcard
    C.start
  ]

  delete: Fn.pipe [
    ( specifier ) ->
      HTTP.delete { resource: @locator, specifier... }
    C.make
    C.delete
    C.wildcard
    C.start
  ]

export default Broadway
