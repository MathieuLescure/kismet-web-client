'use strict'

describe 'Filter: bssidTypeFilter', () ->

  # load the filter's module
  beforeEach module 'kismetwebclientApp'

  # initialize a new instance of the filter before each test
  bssidTypeFilter = {}
  beforeEach inject ($filter) ->
    bssidTypeFilter = $filter 'bssidTypeFilter'

  ###it 'should return the input prefixed with "bssidTypeFilter filter:"', () ->
    text = 'angularjs'
    expect(bssidTypeFilter text).toBe ('bssidTypeFilter filter: ' + text)###
