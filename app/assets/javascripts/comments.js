var Comments = {
	init: function(){
		$('body').on("ajax:success", '#comment-reply', this.addComment)
		$('body').on("ajax:success", '.reply', this.addReplyForm)
		$('body').on("click", '.shrink', this.toggleShrink)
		$('body').on("click", '.unshrink', this.toggleShrink)
		$('body').on("click", '.cancel', this.removeForm)
		$('body').on("ajax:success", '.vote', this.updateRating)
		$('body').on("ajax:success", '.bounty_comment_form', this.addNewBountyComment)
		$('body').on("ajax:success", '.product_comment_form', this.addNewProductComment)
		this.collapseGrandChildren()
	},

	addReplyForm: function(event, data, status, xhr){
		var comment = $(event.currentTarget).parents().eq(3)
		var reply_box = comment.children('.reply-section')
		$('.reply-section').empty()
		reply_box.html(data)
	},

	removeForm: function(event){
		event.preventDefault()
		$('.reply-section').empty()
	},

	addComment: function(event, data, status, xhr){
		var comment = $(event.currentTarget).parents().eq(3)
		var comment_box = comment.children('.nested_comments')
		$('.reply-section').empty()
		data += '<div class="nested_comments"></div>'
		comment_box.append(data)
	},

	toggleShrink: function(event){
		event.preventDefault()
		var commentTree = $(this).parents().eq(4)
		commentTree.children().toggle()
	},

	collapseGrandChildren: function(){
		$('.comment-nest > * > * > * > * > * > * > * > * > .shrink').click()
		$('.comment-nest > * > * > * > * > * > * > * > * > * > * > .unshrink').click()	
	},

	updateRating: function(event, comment, status, xhr){
		$(event.currentTarget).parent().children('h5').html(comment.rating)
	},

	addNewBountyComment: function(evt, data, status, xhr){
		var responseArea = $(evt.currentTarget).parents().eq(2).children('.bounty-responses')
    var responseThread = responseArea.children('.thread')
    if(responseThread.length == 0) {
      responseArea.empty()
      responseArea.append('<div style="display: inline-block;" class="thread"></div>')
    }
    data += '<div class="nested_comments"></div>'
    responseThread.prepend("<div class='comment-nest'>" + data + "</div>");
    $('.comment_form_body').val('');
	},

	addNewProductComment: function(evt, data, status, xhr){
	 	data += '<div class="nested_comments"></div>'
    var thread = $(evt.currentTarget).parents().eq(2).children('#comment-container').children('.thread')
    thread.prepend("<div class='comment-nest'>" + data + "</div>");
    $('#comment_body').val('');
	}
}

$(document).ready(function(){
	Comments.init()
})
