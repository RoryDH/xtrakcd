xtrakcd = angular.module('xtrakcd')

xtrakcd.directive("comicImage", [->
  restrict: "E"
  scope:
    comic: "="

  replace: true
  template: """
    <div class='modal-image-wrap'>
      <div class=\"text-muted image-message\" ng-show=\"imageStatus === 0\">
        <i class=\"fa fa-arrow-down\"></i> Loading image...
      </div>
      <div class=\"text-danger image-message\" ng-show=\"imageStatus === 2\">
        <i class=\"fa fa-times\"></i> Error getting comic image...
      </div>
      <img ng-src="{{comic.img_url}}" title="{{comic.alt_text}}" ng-show="imageStatus"/>
    </div>
  """

  link: (scope, element, attrs) ->
    scope.imageStatus = 0
    element.find("img").bind "error", ->
      scope.imageStatus = 2
      scope.$apply()

    element.find("img").bind "load", ->
      scope.imageStatus = 1
      scope.$apply()

    scope.$watch "imgUrl", ->
      scope.imageStatus = 0
])

xtrakcd.directive("loader", [->
  restrict: "AE"
  replace: true
  template: """
    <div class="spinner">
      <div class="rect1"></div>
      <div class="rect2"></div>
      <div class="rect3"></div>
      <div class="rect4"></div>
      <div class="rect5"></div>
    </div>
  """
])
