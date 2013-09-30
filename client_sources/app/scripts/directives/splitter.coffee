'use strict';

angular.module('kismetwebclientApp')
  .directive('splitter', ($document) ->
    #template: '<div></div>'
    #restrict: 'A'
    link: (scope, element, attrs) ->
      startY = 0
      initialMouseY = 0
      prevHeight = 0
      nextHeight = 0

      prevElt = element.prev()
      nextElt = element.next()

      element.css {
        height: '4px'
        width: '100%'
        position: 'relative'
        top: '-2px';
        'background-color': 'lightgray'
        'z-index': '10'
        cursor: 'row-resize'
      }

      prevElt.css { 
        height: '50%'
        position: 'relative'
        overflow: 'hidden'
        'padding-bottom': '2px'
      }
      nextElt.css { 
        height: '50%'
        position: 'relative'
        overflow: 'hidden'
        'margin-top': '-2px'
      }

      mousemove = (evt) ->
        offsetY = evt.clientY - initialMouseY
        prevHP = Math.round (prevHeight + offsetY) / (prevHeight + nextHeight) * 100
        nextHP = 100 - prevHP;

        prevElt.css { height: prevHP + '%' }
        nextElt.css { height: nextHP + '%' }

      mouseup = () ->
        $document.unbind 'mousemove', mousemove
        $document.unbind 'mouseup', mouseup
        scope.$broadcast('splittermoved')

      element.on 'mousedown', (evt) ->
        $document.bind 'mousemove', mousemove
        $document.bind 'mouseup', mouseup

        startY = element.prop 'offsetTop'
        initialMouseY = evt.clientY
        prevHeight = prevElt.height()
        nextHeight = nextElt.height()

        prevElt.css {height: prevElt.height() + 'px'}
        nextElt.css {height: nextElt.height() + 'px'}

        return false;
  )
