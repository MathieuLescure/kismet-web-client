'use strict';

angular.module('kismetwebclientApp')
  .filter 'unixTimestampFilter', ($filter) ->
    (input, format) ->
      $filter('date')(input * 1000, format)
