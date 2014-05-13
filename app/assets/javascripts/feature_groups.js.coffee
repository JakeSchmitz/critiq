# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

FeatureGroup = 
	init: ->
		@addOption()
		$('.another').on "click", @addAnotherOption
	addOption: () ->
		if $('.alert').text() == "×Feature group was successfully created."
			$('.alert').remove()
			$('.comparison-header').last().parent().children('button').click()
			$('html, body').animate scrollTop: 950, duration: 1
	addAnotherOption: () ->
		delay = (ms, func) -> setTimeout func, ms
		delay 1000, ->
			$('.comparison-header').last().children('button').click()
			$('form').each (i) ->
				@.reset()

$(document).ready ->
	FeatureGroup.init()