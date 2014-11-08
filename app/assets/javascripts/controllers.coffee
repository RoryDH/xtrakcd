xtrakcd = angular.module('xtrakcd')

xtrakcd.controller("MainCtrl", [
  '$scope'
  '$http'
  '$location'
  '$modal'
  'Resp'
  ($scope, $http, $location, $modal, Resp) ->
    $scope.u = null
    $scope.setUser = (u) ->
      $scope.u = u

    $http.get('/api/me')
    .success (u) ->
      $scope.setUser u if u.name

    $scope.logout = ->
      $http.post('/api/u/out', null)
      .success (data) ->
        $scope.setUser null if data.authStatus is 'out'

    $scope.currentC = null
    cModal = $modal(
      template: "comic_modal.html"
      show: false
      scope: $scope
      animation: "am-fade-and-scale"
      backdrop: true
      backdropAnimation: "am-fade"
    )
    $scope.openComicModal = (comic) ->
      $scope.currentC = comic
      cModal.show() if Resp.now("xs")
    $scope.closeCurrent = ->
      # console.log cModal
      # cModal && cModal.hide()
      $scope.showAltText = false
      $scope.currentC = null

    $scope.registerModal = ->
      regModal = $modal(
        template: "/views/register.html"
        scope: $scope
      )

    $scope.gotoSearch = (query) ->
      $scope.currentC = null
      $location.path('/').search('q', query)

])

xtrakcd.controller("ListCtrl", [
  '$scope'
  '$routeParams'
  'Comic'
  ($scope, $routeParams, Comic) ->
    $scope.comics = Comic.list({q: $routeParams.q})
    $scope.comicModalByIndex = (i) ->
      $scope.openComicModal $scope.comics[i]
])

xtrakcd.controller("ComicModalCtrl", [
  '$scope'
  ($scope) ->
    $scope.test = 1
])

xtrakcd.controller("RegisterCtrl", [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.newU = {}
    $scope.create = ->
      $scope.registering = true
      $scope.registerServer = undefined
      $http.post('/api/u', $scope.newU)
      .success ->
        $scope.closeRegister()
        $scope.registering = false
      .error (err) ->
        $scope.registering = false
        if err.saveErrors
          $scope.registerServer = err
        else
          $scope.registerServer = {"Error": [
            "There was an unknown problem registering, refresh and try again."
          ]}
])

xtrakcd.controller("LoginCtrl", [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.login = ->
      $scope.loggingIn = true
      $scope.loginServer = []
      $http.post('/api/u/in', $scope.lUser)
      .success (u) ->
        $scope.closeLogin()
        $scope.loggingIn = false
        $scope.setUser u
      .error (err) ->
        $scope.loggingIn = false
        if err.errors
          $scope.loginServer = err.errors
        else
          $scope.loginServer = ["Login Error"]
])


