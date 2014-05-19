# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@selectImage = (id) ->
	oldPic = $('#main-pic').css("background-image")
	newPic = $('#alt-pic' + id).css("background-image")
	$('#main-pic').html("")
	$('#main-pic').css("background-image", newPic)

@embedVideo = (video_url) ->
	$('#main-pic').html('')
	$('#main-pic').css('background-image', 'none')
	$('#main-pic').append(video_url)

Products = 
	init: ->
		@showFeatures()
		@showLikes()
	showFeatures: ->
		$('#product-tabs a[href="#drive-info').tab 'show'
	showLikes: ->
		$('#u_0_2').css 'color', '#fff'

$(document).ready ->
	Products.init()
