'use strict'

angular.module('kismetwebclientApp', ['btford.socket-io', 'ngGrid'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
