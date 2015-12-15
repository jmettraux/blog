
posts:
	bundle exec ruby lib/render_posts.rb

new:
	touch posts/`date +"%Y%m%d"`.md

.PHONY: posts

