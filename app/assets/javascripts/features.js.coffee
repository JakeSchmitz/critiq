Features = 
	init: () ->
		$('body').on 'click', '.form-button', @showFeatureForm
		$('body').on 'click', '.add-option', @showOptionForm
		$('body').on 'click', '.feature-modal-btn', @showFeatureModal
		$('body').on 'ajax:complete', '.option-form', @addOption
		$('body').on 'ajax:complete', '#singleton-create-form', @addSingleton
		@proceedToOption()

	showFeatureForm: (event) ->
		compForm = $(event.currentTarget).parents().eq 3
		compForm.modal 'hide'

	showOptionForm: (event) ->
		console.log "option"
		optionForm = $($(event.currentTarget).context.nextElementSibling)
		optionForm.modal 'show'

	showFeatureModal: (event) ->
		console.log($(@).parent().next())
		featureModal = $(@).parent().next()
		featureModal.modal 'show'

	addOption: (event, data, status, xhr) ->
		optionForm = $($(@).context.parentNode).parent().parent()
		thumbnails = $(optionForm).parent()
		thumbnails.children('.add-option').before data.responseText 
		optionForm.modal 'hide'

	addSingleton: (event, data, status, xhr) ->
		$('#singleton-form').modal 'hide'
		$('#singleton-thumbnails').append data.responseText 

	proceedToOption: () ->
		if $('.alert').text() == "×Feature group was successfully created."
			$('.alert').remove()
			$('.add-option').last().click()
			$('html, body').animate scrollTop: 950, duration: 1

$(document).ready ->
	Features.init()


		

