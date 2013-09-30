'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'kismetwebclientApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope,
      socket: {
        forward: () ->
      }
    }

  it 'clientStore', () ->
    expect(scope.clientStore.list.length).toBe 0
    scope.$broadcast('socket:CLIENT', { mac:'123'})
    expect(scope.clientStore.list.length).toBe 1
    scope.$broadcast('socket:CLIENT', { mac:'1234'})
    expect(scope.clientStore.list.length).toBe 2
    scope.$broadcast('socket:CLIENT', { mac:'123'})
    expect(scope.clientStore.list.length).toBe 2

