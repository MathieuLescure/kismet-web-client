'use strict'

describe 'Filter: unixTimestampFilter', () ->

  # load the filter's module
  beforeEach module 'kismetwebclientApp'

  # initialize a new instance of the filter before each test
  unixTimestampFilter = {}
  beforeEach inject ($filter) ->
    unixTimestampFilter = $filter 'unixTimestampFilter'

  ###it 'should return the input prefixed with "unixTimestampFilter filter:"', () ->
    text = 'angularjs'
    expect(unixTimestampFilter text).toBe ('unixTimestampFilter filter: ' + text)###
