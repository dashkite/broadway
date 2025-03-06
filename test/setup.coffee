import $ from "../src"
import Providers from "@dashkite/belmont/providers"

Providers.add "https", $

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
