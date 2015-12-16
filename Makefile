
render: index all posts atom

rp: render publish

index:
	bundle exec ruby -Ilib lib/render_index.rb
all:
	bundle exec ruby -Ilib lib/render_all.rb
posts:
	bundle exec ruby -Ilib lib/render_posts.rb
atom:
	bundle exec ruby -Ilib lib/render_atom.rb

new:
	bundle exec ruby -Ilib lib/new_post.rb

publish:
	rsync -av out/ ~/Dropbox/Public/blog

