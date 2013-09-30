'use strict'

angular.module('kismetwebclientApp')
  .controller 'MainCtrl', ($scope, socket) ->
    
    ## Helpers -----------------------------------------
    class Store
      constructor: (@keyField) ->
        @hashtable = {}
        @list = []

      insert: (item) ->
        key = 'key' + item[@keyField]
        if @hashtable[key]?
          index = @hashtable[key]
          @list[index] = item
        else
          @hashtable[key] = @list.push(item) - 1

    

    ## Init ---------------------------------------------
    $scope.clientStore = new Store 'mac'
    $scope.bssidStore = new Store 'bssid' 

    $scope.connectionStatus = 'disconnected'
    $scope.kismetServerConnectionStatus = 'disconnected'

    bssidGridLayoutPlugin = new ngGridLayoutPlugin()
    clientGridLayoutPlugin = new ngGridLayoutPlugin()

    $scope.bssidGridOptions =
      enableColumnResize: true,
      enableColumnReordering: true,
      multiSelect: false,
      enableHighlighting: true,
      data: 'bssidStore.list',
      plugins: [bssidGridLayoutPlugin],
      columnDefs: [
        { field: 'bssid', width: 150, pinned: true },
        { field: 'type', width: 130, cellFilter:'bssidTypeFilter'},
        { field: 'manuf', width: 130, displayName: 'manufacturer'},
        { field: 'channel', width: 50 },
        { field: 'signal_dbm', width: 50, displayName: 'dbm' },
        { field: 'minsignal_dbm', width: 50, displayName: 'min dbm' },
        { field: 'maxsignal_dbm', width: 50, displayName: 'max dbm' },
        { field: 'firsttime', width: 130, displayName: 'first seen', cellFilter:"unixTimestampFilter:'MMM dd, HH:mm:ss'"},
        { field: 'lasttime', width: 130, displayName: 'last seen', cellFilter:"unixTimestampFilter:'MMM dd, HH:mm:ss'" },
        { field: 'llcpackets', width: 80, displayName: 'llc pkts' },
        { field: 'datapackets', width: 80, displayName: 'data pkts' },
        { field: 'cryptpackets', width: 80, displayName: 'crypt pkts' }
      ]

#
#


    $scope.clientGridOptions =
      enableColumnResize: true,
      enableColumnReordering: true,
      multiSelect: false,
      enableHighlighting: true,
      data: 'clientStore.list',
      plugins: [clientGridLayoutPlugin],
      columnDefs: [
        { field: 'mac', width: 150, pinned: true }
        { field: 'bssid', width: 150 },
        { field: 'type', width: 130, cellFilter:'clientTypeFilter'},
        { field: 'manuf', width: 130, displayName: 'manufacturer'},
        { field: 'channel', width: 50 },
        { field: 'signal_dbm', width: 50, displayName: 'dbm' },
        { field: 'minsignal_dbm', width: 50, displayName: 'min dbm' },
        { field: 'maxsignal_dbm', width: 50, displayName: 'max dbm' },
        { field: 'firsttime', width: 130, displayName: 'first seen', cellFilter:"unixTimestampFilter:'MMM dd, HH:mm:ss'"},
        { field: 'lasttime', width: 130, displayName: 'last seen', cellFilter:"unixTimestampFilter:'MMM dd, HH:mm:ss'"},
        { field: 'llcpackets', width: 80, displayName: 'llc pkts' },
        { field: 'datapackets', width: 80, displayName: 'data pkts' },
        { field: 'cryptpackets', width: 80, displayName: 'crypt pkts' },
        { field: 'datasize', width: 80, displayName: 'data size' }
      ]

    setInterval () -> 
      $scope.$apply()
    , 1000

    $scope.$on 'splittermoved', () ->
      bssidGridLayoutPlugin.updateGridLayout()
      clientGridLayoutPlugin.updateGridLayout()

    ## Socket -------------------------------------------
    socket.forward 'connect', $scope
    socket.forward 'connecting', $scope
    socket.forward 'connect_failed', $scope
    socket.forward 'disconnect', $scope
    socket.forward 'reconnect', $scope
    socket.forward 'reconnecting', $scope
    socket.forward 'reconnect_failed', $scope
    socket.forward 'error', $scope
    socket.forward 'kismetServerConnectionStatus', $scope
    socket.forward 'BSSID', $scope
    socket.forward 'CLIENT', $scope

    connecting = (evt, data) ->
      console.log('connecting')
      $scope.connectionStatus = 'connecting'

    connected = (evt, data) ->
      console.log('connected')
      $scope.connectionStatus = 'connected'

    disconnected = (evt, data) ->
      console.log('disconnected')
      $scope.connectionStatus = 'disconnected'

    $scope.$on 'socket:connecting', connecting
    $scope.$on 'socket:reconnecting', connecting

    $scope.$on 'socket:connect', connected
    $scope.$on 'socket:reconnect', connected
      
    $scope.$on 'socket:disconnect', disconnected
    $scope.$on 'socket:connect_failed', disconnected
    $scope.$on 'socket:reconnect_failed', disconnected

    $scope.$on 'socket:kismetServerConnectionStatus', (evt, data) ->
      $scope.kismetServerConnectionStatus = if data.isConnected then 'connected' else 'disconnected'

    $scope.$on 'socket:CLIENT', (evt, client) ->
      $scope.clientStore.insert(client)

    $scope.$on 'socket:BSSID', (evt, bssid) ->
      $scope.bssidStore.insert(bssid)
