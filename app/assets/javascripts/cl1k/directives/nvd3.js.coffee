angular.module('cl1k.directives').directive('nvd3StackedArea', () ->
  restrict: 'A'
  scope:
    data: '='
  link: (scope, element, attr) ->

    nv.addGraph ->

      chart = nv.models.stackedAreaChart()
      chart.x((d) -> d[0])
      chart.y((d) -> d[1])
      chart.clipEdge true
      
      chart.xAxis
          .tickFormat((d) -> d3.time.format('%x')(new Date(d)));

      chart.yAxis
         .tickFormat(d3.format(',.2f'));

      element.html '<svg></svg>'

      d3.select(element.find('svg').attr('height', '300px')[0])
       .datum(scope.data)
         .transition().duration(500).call(chart);

      nv.utils.windowResize(chart.update)

      scope.chart = chart
 ); 
