
render: all posts

all:
	bundle exec ruby -Ilib lib/render_all.rb
posts:
	bundle exec ruby -Ilib lib/render_posts.rb

new:
	touch posts/`date +"%Y%m%d"`.md

publish:
	rsync -av out/ ~/Dropbox/Public/blog

.PHONY: posts publish

