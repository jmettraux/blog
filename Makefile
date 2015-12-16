
posts:
	bundle exec ruby -Ilib lib/render_posts.rb

new:
	touch posts/`date +"%Y%m%d"`.md

.PHONY: posts

