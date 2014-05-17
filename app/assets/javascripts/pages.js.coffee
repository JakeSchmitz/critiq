Pages =
	init: () ->
		$('#home_drives .pagination a').on 'click', @paginate

	paginate: () ->
		$.getScript @.href
		false


$(document).ready ->
	Pages.init()

