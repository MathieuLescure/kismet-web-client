'use strict';

angular.module('kismetwebclientApp')
  .filter 'clientTypeFilter', () ->
    clientTypes = { '0':'Unknown', '1':'From DS', '2':'To DS', '3':'Inter DS', '4':'Established', '5':'Ad-hoc', '6':'Remove' }
    (input) ->
      clientTypes[input]
