Comments = 
	init: ->
		$('body').on "ajax:success", '#comment-reply', @addComment
		$('body').on "ajax:success", '.reply', @addReplyForm
		$('body').on "click", '.shrink', @toggleShrink
		$('body').on "click", '.unshrink', @toggleShrink
		$('body').on "click", '.cancel', @removeForm
		$('body').on "ajax:success", '.vote', @updateRating
		$('body').on "ajax:success", '.bounty_comment_form', @addNewBountyComment
		$('body').on "ajax:success", '.product_comment_form', @addNewProductComment
		$('body').on "ajax:success", '.delete-comment', @deleteComment
		@collapseGrandChildren()

	addReplyForm: (event, data, status, xhr) ->
		comment = $(event.currentTarget).parents().eq 3
		reply_box = comment.children('.reply-section')
		$('.reply-section').empty()
		reply_box.html(data)
	
	removeForm: (event) ->
		event.preventDefault()
		$('.reply-section').empty()
	
	addComment: (event, data, status, xhr) ->
		console.log 'tried'
		comment = $(event.currentTarget).parents().eq 3
		comment_box = comment.children '.nested_comments'
		$('.reply-section').empty()
		data += '<div class="nested_comments"></div>'
		comment_box.append data
	
	toggleShrink: (event) ->
		event.preventDefault()
		commentTree = $(this).parents().eq 4
		commentTree.children().toggle()
	
	collapseGrandChildren: () ->
		$('.comment-nest > * > * > * > * > * > * > * > * > .shrink').click()
		$('.comment-nest > * > * > * > * > * > * > * > * > * > * > .unshrink').click()	

	updateRating: (event, comment, status, xhr) ->
		$(event.currentTarget).parent().children('h5').html comment.rating

	addNewBountyComment: (evt, data, status, xhr) ->
		responseArea = $(evt.currentTarget).parents().eq(2).children '.bounty-responses'
		responseThread = responseArea.children '.thread'
		if responseThread.length == 0 
      responseArea.empty()
      responseArea.append('<div style="display: inline-block;" class="thread"></div>')
    
    data += '<div class="nested_comments"></div>'
    responseThread.prepend "<div class='comment-nest'>" + data + "</div>" 
    $('.comment_form_body').val '';
	
	addNewProductComment: (evt, data, status, xhr) ->
		data += '<div class="nested_comments"></div>'
		thread = $(evt.currentTarget).parents().eq(2).children('#comment-container').children '.thread'
		thread.prepend "<div class='comment-nest'>" + data + "</div>"
		$('#comment_body').val ''

	deleteComment: (evt, data, status, xhr) ->
		commentBody = $(evt.currentTarget).parents().eq(2).children '.comment-text' 
		commentBody[0].innerHTML = data.body

$(document).ready ->
	Comments.init()


