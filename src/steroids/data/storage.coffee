{Bacon} = require 'baconjs'

class PubSubChannel
  outboundBus = (name) ->
    bus = new Bacon.Bus

    bus
      .map (message) ->
        channel: name
        message: message
      .onValue (data) ->
        window.postMessage data

    bus

  inboundStream = (name) ->
    Bacon.fromEventTarget(window, "message")
      .filter((event) -> event.data.channel is name)
      .map((event) -> event.data.message)

  constructor: (@name) ->
    @outbound = outboundBus @name
    @inbound = inboundStream @name

  publish: (value) =>
    @outbound.push value

  subscribe: (listener) =>
    @inbound.onValue listener

class LocalStorageProperty
  _channel: null
  _defaultValue: null

  # String
  name: null

  # Bacon.Property
  values: null

  constructor: (@name, @_defaultValue = null) ->
    @_channel = new PubSubChannel "steroids.data.storage.LocalStorageProperty:#{@name}"
    @values = @_channel.outbound.merge(@_channel.inbound).toProperty(@get()).skipDuplicates()

  set: (value) ->
    localStorage.setItem @name, JSON.stringify value
    @_channel.publish value
    this

  get: ->
    value = localStorage.getItem @name
    if value?
      JSON.parse value
    else
      @_defaultValue

  unset: ->
    localStorage.removeItem @name
    @_channel.publish @_defaultValue
    this

module.exports =
  property: (name) -> new LocalStorageProperty name
