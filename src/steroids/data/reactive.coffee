{Bacon} = require 'baconjs'

# TODO: Remove hard dependency in window.document
visibilityState = Bacon.fromEventTarget(window.document, 'visibilitychange')
  .map((event) ->
    event.target?.visibilityState
  )
  .toProperty(window.document.visibilityState)
  .map((stateString) ->
    switch stateString
      when "visible" then true
      when "hidden" then false
      else false
  )

whenVisible = visibilityState.filter((v) -> v)

module.exports = {
  whenVisible
}