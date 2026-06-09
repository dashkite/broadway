import express from "express"
import cors from "cors"
import api from "./api"
import { state } from "./state"

Address = make: -> Math.random().toString( 36 )[ 2.. ]

app = express()

app.use cors
  origin: true
  methods: [ "GET", "PUT", "POST", "DELETE" ]
  allowedHeaders: [ "authorization", "content-type" ]
  exposedHeaders: [ "location" ]

app.use express.json()

app.get "/", ( request, response ) ->
  response.status( 200 ).json api

app.get "/posts", ( request, response ) ->
  response.status( 200 ).json Object.values state.posts

app.post "/posts", ( request, response ) ->
  address = Address.make()
  state.posts[ address ] = { address, request.body... }
  response
    .status( 201 )
    .set "location", "/posts/#{ address }"
    .json state.posts[ address ]

app.get "/posts/:address", ( request, response ) ->
  { address } = request.params
  if ( post = state.posts[ address ] )?
    response.status( 200 ).json post
  else
    response.status( 404 ).send()

app.put "/posts/:address", ( request, response ) ->
  { address } = request.params
  exists = state.posts[ address ]?
  state.posts[ address ] = { address, request.body... }
  response
    .status if exists then 200 else 201
    .json state.posts[ address ]

app.delete "/posts/:address", ( request, response ) ->
  { address } = request.params
  post = state.posts[ address ]
  delete state.posts[ address ]
  response.status( 200 ).json post

Servers =

  start: ( port = 3001 ) ->
    new Promise ( resolve ) =>
      @_server = app.listen port, resolve

  stop: ->
    new Promise ( resolve ) =>
      @_server.close resolve

export default Servers
