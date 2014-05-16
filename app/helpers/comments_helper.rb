module CommentsHelper

	def nested_comments comments, product
  		comments.map do |comment, sub_comments|
	    	content_tag(:div,  (render partial: '/comments/comment',
	    	 locals: {comment: comment, product: product, commentable: product, reply: [product, comment] }) + 
	    	content_tag(:div, nested_comments(sub_comments, product), :class => "nested_comments"), 
	    	:class => "comment-nest")
  		end.join.html_safe
	end


	def nested_bounty_comments comments, product, bounty
		comments.map do |comment, sub_comments|
	    	content_tag(:div,  (render partial: '/comments/comment',
	    	 locals: {comment: comment, product: product, commentable: bounty, reply: [product, bounty, comment] }) + 
	    	content_tag(:div, nested_comments(sub_comments, product), :class => "nested_comments"), 
	    	:class => "comment-nest")
  		end.join.html_safe
	end

	def width_for comment
		length = 750
		indentation = 38
		"#{750 - comment.depth * 37}px"
	end

	def reply_count_for comment
		"#{comment.subtree.count - 1} replies" 
	end

end
