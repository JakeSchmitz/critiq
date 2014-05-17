# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

FeatureGroup = 
	init: ->
		$('.another').on "click", @addAnotherOption

	addAnotherOption: () ->
		delay = (ms, func) -> setTimeout func, ms
		delay 1000, ->
			$('.comparison-header').last().children('button').click()
			$('form').each (i) ->
				@.reset()

$(document).ready ->
	FeatureGroup.init()