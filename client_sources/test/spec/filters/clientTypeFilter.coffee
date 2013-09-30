'use strict'

describe 'Filter: clientTypeFilter', () ->

  # load the filter's module
  beforeEach module 'kismetwebclientApp'

  # initialize a new instance of the filter before each test
  clientTypeFilter = {}
  beforeEach inject ($filter) ->
    clientTypeFilter = $filter 'clientTypeFilter'

  ###it 'should return the input prefixed with "clientTypeFilter filter:"', () ->
    text = 'angularjs'
    expect(clientTypeFilter text).toBe ('clientTypeFilter filter: ' + text)###
