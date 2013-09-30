'use strict';

angular.module('kismetwebclientApp')
  .filter 'bssidTypeFilter', () ->
    bssidTypes = { '0':'Access Point', '1':'Ad-hoc', '2':'Probe request', '3':'Turbocell', '4':'Data' }
    (input) ->
      bssidTypes[input]
