angular.module('cl1k.services').factory 'Redirect', [
	'railsResourceFactory'
	(railsResourceFactory) ->
		railsResourceFactory
			url: '/redirects',
			name: 'redirect'
]
