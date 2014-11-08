xtrakcd = angular.module('xtrakcd')

xtrakcd.config([
  '$routeProvider'
  '$tooltipProvider'
  '$modalProvider'
  '$popoverProvider'
  '$dropdownProvider'
  ($routeProvider, $tooltipProvider, $modalProvider, $popoverProvider, $dropdownProvider) ->
    $routeProvider.when('/',
      templateUrl: 'list.html'
      controller: 'ListCtrl'
    ).when '/c/:number',
      templateUrl: 'views/comic.html'
      controller: 'ShowComicCtrl'

    angular.extend $tooltipProvider.defaults,
      # animation: null
      trigger: 'hover'
      placement: 'bottom'
      container: 'body'

    angular.extend $modalProvider.defaults,
      container: 'body'
      # animation: null
      backdropAnimation: null

    angular.extend $popoverProvider.defaults,
      container: 'body'
      animation: null

    angular.extend $dropdownProvider.defaults,
      animation: null

])

xtrakcd.filter('cap', ->
  (input, scope) ->
    if input != null
      input = input.toLowerCase()
      input.substring(0,1).toUpperCase() + input.substring(1)
)

xtrakcd.filter('unsafe', ['$sce', ($sce) ->
  (val) -> $sce.trustAsHtml(val)
])
