xtrakcd = angular.module('xtrakcd')

xtrakcd.factory('Comic', [
  '$resource'
  ($resource) ->
    $resource('/api/v1/c/:number', null, {
      'list': {
        method: 'GET',
        transformResponse: (data) -> angular.fromJson(data).comics,
        isArray: true
      }
    })
])

xtrakcd.factory("Resp", [
  ->
    px = -> window.innerWidth
    res = ->
      s = px()
      return "lg" if s >= 1200
      return "md" if s >= 992
      return "sm" if s >= 768
      "xs"

    px: px
    res: res
    now: (s) -> res() == s
])
