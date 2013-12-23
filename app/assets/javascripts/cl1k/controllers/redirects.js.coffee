angular.module('cl1k.controllers')
  .controller('redirectsController', ['$scope', '$http', 'Redirect',
  ($scope, $http, Redirect) ->

    setRedirects = (redirects) ->
      redirects or= []
      redirects.push target: 'Add new' unless _.find(redirects, (r) -> r.target == 'Add new')
      $scope.redirects = redirects

    Redirect.query().then (results) -> setRedirects results
    
    $scope.chosenRedirect = false

    $scope.charts = {} 

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

    fillInMissingDaysForChart = (data) ->
      minDay = _.min(_.map(data, (series) -> series.values[0][0]))
      maxDay = _.max(_.map(data, (series) -> _.last(series.values)[0]))
      currentDay = minDay
      dayIndex = 0
      loop
        break if currentDay > maxDay
        _.each data, (series, seriesIndex) ->
          if not series.values[dayIndex] or
            series.values[dayIndex][0] != currentDay
              data[seriesIndex].values.splice dayIndex, 0, [currentDay, 0]
        dayIndex++
        currentDay += 60*60*24*1000
      data

    $scope.addRedirectChart = (redirect) ->
      chart = redirect: redirect, dimension: 'platform'
      $http.get("/redirects/#{chart.redirect.id}/clicks/by/#{chart.dimension}").success((results) ->
        chart.data = fillInMissingDaysForChart results
        $scope.charts[chart.redirect.id] = chart
      )

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
