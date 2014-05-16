Features = 
	init: () ->
		$('body').on 'click', '.comp-button', @showCompForm

	showCompForm: (event) ->
		console.log(event.currentTarget)
		compForm = $(event.currentTarget).parents().eq 3
		compForm.modal 'hide'

$(document).ready ->
	Features.init()


		

