'use strict'

describe 'Directive: splitter', () ->

  # load the directive's module
  beforeEach module 'kismetwebclientApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  ###it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<splitter></splitter>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the splitter directive'###
