angular.module('cl1k.controllers')
  .controller('redirectsController', ['$scope', 'Redirect', 
  ($scope, Redirect) ->

    setRedirects = (redirects) ->
      redirects or= []
      redirects.push target: 'Add new' unless _.find(redirects, (r) -> r.target == 'Add new')
      $scope.redirects = redirects

    Redirect.query().then (results) -> setRedirects results
    
    $scope.chosenRedirect = false

    initializeNewRedirect = () ->
      $scope.newRedirect = 
        target: 'http://'

    initializeNewRedirect()

    $scope.newRedirectValid = ->
      $scope.newRedirect.target.match /^https?\:\/\//

    $scope.deleteRedirect = ->
      new Redirect($scope.chosenRedirect).delete()
        .then (redirect) ->
          setRedirects _.reject($scope.redirects, (r) -> r.id is $scope.chosenRedirect.id)
          $scope.chosenRedirect = _.first $scope.redirects

    $scope.addRedirectChart = ->
      alert "adding chart for #{$scope.chosenRedirect.slug}"

    $scope.createRedirect = ->
      if _.find($scope.redirects, (r) -> return r.target is $scope.newRedirect.target)
        return $scope.newRedirect.errors = ["is already in your list of shortlinks"]
      new Redirect($scope.newRedirect).create()
        .then (redirect) ->
          addOne = $scope.redirects.pop()
          $scope.redirects.push redirect, addOne
          $scope.chosenRedirect = redirect
          initializeNewRedirect()
       ,  (error) ->
            if error.data and error.data.errors and error.data.errors.target
              $scope.newRedirect.errors = error.data.errors.target
              
  ])
