Users = 
	init: () ->
		@showFirstTab

	showFirstTab: () ->
		$('.creation-tab').first().tab 'show'