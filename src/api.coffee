Q = require 'q'

address = window.location.protocol + '//' + window.location.host + '/api'

ajax = (method, url, data, relative = true) ->
  Q $.ajax
    url: if relative then address + url else url
    data: data
    method: method

module.exports =
  address: address
  get: ajax.bind undefined, 'GET'
  put: ajax.bind undefined, 'PUT'
  post: ajax.bind undefined, 'POST'
  del: ajax.bind undefined, 'DELETE'
