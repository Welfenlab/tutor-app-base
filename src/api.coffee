Q = require 'q'

module.exports = ->
  address = window.location.protocol + '/' + window.location.host + '/api'

  ajax = (method, url, data, relative = true) ->
    Q $.ajax
      url: if relative then address + url else url
      data: data
      method: method

  get: ajax.bind undefined, 'GET'
  put: ajax.bind undefined, 'PUT'
  post: ajax.bind undefined, 'POST'
  del: ajax.bind undefined, 'DELETE'
