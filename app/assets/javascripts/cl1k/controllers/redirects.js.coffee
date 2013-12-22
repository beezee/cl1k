angular.module('cl1k.controllers')
  .controller('redirectsController', ['$scope', 'Redirect', 
  ($scope, Redirect) ->
    $scope.redirects = []
    Redirect.query().then (results) -> $scope.redirects = results
  ])
