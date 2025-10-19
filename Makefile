
render: index all posts copyright atom
c: render

#rp: render publish

index:
	bundle exec ruby -Ilib lib/render_index.rb
all:
	bundle exec ruby -Ilib lib/render_all.rb
posts:
	bundle exec ruby -Ilib lib/render_posts.rb
copyright:
	bundle exec ruby -Ilib lib/render_copyright.rb
atom:
	bundle exec ruby -Ilib lib/render_atom.rb

new:
	bundle exec ruby -Ilib lib/new_post.rb
n: new
write:
	$(EDITOR) posts/`ls -1 -t posts/ | head -1`
w: write

publish:
	#rsync -av out/ ~/Dropbox/Public/blog
	  #
	# https://savjee.be/2013/02/howto-host-jekyll-blog-on-amazon-s3/
	#s3cmd sync --acl-public out/ s3://lambda.io/
	#s3cmd sync --acl-public --delete-removed out/ s3://lambda.io/
	#rsync -azv out/ lin:www/blog/
	#rsync -azv out/ shooto:/var/www/htdocs/jmettraux.skepti.ch/
	rsync -azv out/ jutsu:/var/www/htdocs/blog.skepti.ch/
p: publish

serve:
	ruby -run -ehttpd out/ -p7000
s: serve
browse:
	open http://127.0.0.1:7000
b: browse

redate:
	bundle exec ruby -Ilib lib/redate_post.rb posts/`ls -1 -t posts/ | head -1`

backup:
	cd .. && tar cjvf ~/Dropbox/backup/blog_`date +%Y%m%d_%H%M%S`.tbz blog/


.PHONY: backup posts publish redate serve


# TODO: leverage make, don't rewrite each time

