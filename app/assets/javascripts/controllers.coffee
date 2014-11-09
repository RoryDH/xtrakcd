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
      $scope.u = u || {}

    $http.get('/api/me').success (u) ->
      $scope.setUser u.me

    $scope.logout = ->
      $http.delete('/api/out').success (data) ->
        $scope.setUser()

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

    $scope.navFilter = {}
    $scope.gotoSearch = (query) ->
      $scope.currentC = null
      $location.path('/').search('q', query)
])

xtrakcd.controller("ListCtrl", [
  '$scope'
  '$routeParams'
  'Comic'
  ($scope, $routeParams, Comic) ->
    $scope.comicListFilter = {}
    $scope.comics = []

    predicateTypes = ['sort', 'search', 'after', 'before']
    $scope.loadComicList = ->
      $scope.listLoading = true
      $scope.$apply ->
        queryObject = {}
        predicateTypes.forEach (attr) ->
          return unless $scope.comicListFilter[attr]
          angular.extend(queryObject, $scope.comicListFilter[attr].serverAttrs || {})
        $scope.comics = Comic.list(queryObject)
        $scope.comics.$promise.then -> $scope.listLoading = false

    if $routeParams.q
      $scope.navFilter.query = $routeParams.q

    $scope.comicModalByIndex = (i) ->
      $scope.openComicModal $scope.comics[i]
])

xtrakcd.controller("ListFilterController", [
  '$scope'
  'debounce'
  ($scope, debounce) ->
    # Example predicate
    # $scope.comicListFilter['greeting'] =
    #   serverAttrs: {greeting_type: 'hello'} value to send to server
    #   name: 'hello' UI name
    #   dropdown: {<angular.strap dropdown object>}
    #   iconName: 'fa-my-icon'

    premadePredicates =
      sort:
        serverAttrs: { order_dir: 'desc', order_by: 'number' }
        name: 'number descending'
        iconName: 'fa-sort'

    $scope.predicateDropdowns =
      sort: [
        {text: "number", click: "comicListFilter.sort.serverAttrs.order_by = 'number'"}
        {text: "title", click: "comicListFilter.sort.serverAttrs.order_by = 'title'"}
        {divider: true}
        {text: "descending", click: "comicListFilter.sort.serverAttrs.order_dir = 'desc'"}
        {text: "ascending", click: "comicListFilter.sort.serverAttrs.order_dir = 'asc'"}
      ]

    if $scope.navFilter.query
      $scope.comicListFilter['search'] =
      value: $scope.navFilter.query
      name: "Containing: #{$scope.navFilter.query}"
      serverAttrs: {q: $scope.navFilter.query}
    else
      $scope.comicListFilter['sort'] = premadePredicates.sort

    $scope.availablePredicates = [
      {
        "text": "Sort",
        "click": "addPredicate('sort')"
      },
      {
        "divider": true
      },
      {
        "text": "Clear filter",
        "click": "comicListFilter = {}"
      }
    ]
    $scope.addPredicate = (type) ->
      predicate = premadePredicates[type]
      $scope.comicListFilter[type] = predicate if predicate
    $scope.removePredicate = (type) -> delete $scope.comicListFilter[type]

    # $scope.loadComicList()

    loadComicListDebounced = debounce($scope.loadComicList, 1200, false)
    $scope.$watch('comicListFilter', ( ->
      loadComicListDebounced()
    ), true)
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
      $http.post('/api/in', $scope.lUser)
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

