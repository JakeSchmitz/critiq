# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@selectImage = (id) ->
	oldPic = $('#main-pic').css("background-image")
	newPic = $('#alt-pic' + id).css("background-image")
	$('#main-pic').css("background-image", newPic)
	$('#alt-pic' + id).css("background-image", oldPic)

Products = 
	init: ->
		@showFeatures()
	showFeatures: ->
		$('#product-tabs a[href="#product-features').tab 'show'

$(document).ready ->
	Products.init()
