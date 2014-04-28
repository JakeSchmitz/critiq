module ProductsHelper
  def has_features?
  	set_product
    !@product.features.empty?
  end

	def youtube_embed(youtube_url)
	  if youtube_url[/youtu\.be\/([^\?]*)/]
	    youtube_id = $1
	  else
	    # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
	    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    youtube_id = $5
	  end

	  %Q{<iframe title="YouTube video player" width="480" height="360" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
	end

	def vimeo_embed(vimeo_url)
	  if vimeo_url[/vimeo\.com\/([^\?]*)/]
	    vimeo_id = $1
	  else
	    vimeo_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    vimeo_id = $5
	  end

	  %Q{<iframe title="Vimeo video player" width="480" height="360" src="\/\/player.vimeo.com\/video\/#{ vimeo_id }" frameborder="0" allowfullscreen></iframe>}
	end

	def vimeo_thumbnail(vimeo_url)
		if vimeo_url[/vimeo\.com\/([^\?]*)/]
	    vimeo_id = $1
	  else
	    vimeo_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    vimeo_id = $5
	  end
	  vim_json = url('http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/' + vimeo_id.to_s)
	  url(vim_json.thumbnail_url)
	end

	def youtube_thumbnail(youtube_url)
		if youtube_url[/youtu\.be\/([^\?]*)/]
	    youtube_id = $1
	  else
	    # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
	    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    youtube_id = $5
	  end
	  url("http://img.youtube.com/vi/" + youtube_id.to_s + "/1.jpg")
	end
end