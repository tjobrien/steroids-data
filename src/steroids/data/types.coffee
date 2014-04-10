module.exports =
  String: (string) ->
    if typeof string is 'string'
      isSuccess: true
    else
      isFailure: true
