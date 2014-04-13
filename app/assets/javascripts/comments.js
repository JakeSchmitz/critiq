// $(document).ready(function(){
//   PaymentGenerator.init()
// })

// var PaymentGenerator = {
//   init: function(){
//     $('.new-payment').on("ajax:success", this.addPaymentButton)
//   },

//   addPaymentButton: function(event, data, status, xhr){
//     $('#new-payment').html(data)
//     $(".stripe-button-el span").text('Pay!')
//   }

var NestedComments = {
	init: function(){
		$('body').on("ajax:success", '#comment-reply', this.addComment)
		$('body').on("ajax:success", '.reply', this.addReplyForm)
		$('body').on("click", '.shrink', this.toggleShrink)
		$('body').on("click", '.unshrink', this.toggleShrink)
		this.collapseGrandChildren()
	},

	addReplyForm: function(event, data, status, xhr){
		var comment = $(event.currentTarget).parents().eq(3)
		var reply_box = comment.children('.reply-section')
		$('.reply-section').empty()
		reply_box.html(data)
	},

	addComment: function(event, data, status, xhr){
		console.log($(event.currentTarget).parents().eq(3))
		var comment = $(event.currentTarget).parents().eq(3)
		var comment_box = comment.children('.nested_comments')
		$('.reply-section').empty()
		data += '<div class="nested_comments"></div>'
		console.log(data)
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
	}
}

$(document).ready(function(){
	NestedComments.init()
})
