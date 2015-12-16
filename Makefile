
render: index all posts

rp: render publish

index:
	bundle exec ruby -Ilib lib/render_index.rb
all:
	bundle exec ruby -Ilib lib/render_all.rb
posts:
	bundle exec ruby -Ilib lib/render_posts.rb

new:
	touch posts/`date +"%Y%m%d"`.md

publish:
	rsync -av out/ ~/Dropbox/Public/blog

.PHONY: posts publish

