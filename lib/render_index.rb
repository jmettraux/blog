
#--
# Copyright (c) 2015-2015, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++

require 'blog'


post_layout = File.read('layouts/index-post.html')
tag_layout = File.read('layouts/index-post-tag.html')

posts =
  Dir['posts/*.md'].reverse.collect do |path|

    print " #{path}"

    vars, content = Blog.load_post(path)

    content = content.split("\n", 2).last # remove title
    content = content.split("\n")[1, 2].join("\n") + "\n&hellip;"
    vars['CONTENT'] = Blog.md_render(content.substitute(vars), index: true)

    vars['ctags'] = vars['tags']
      .collect { |tag| "tag-#{tag}" }
      .join(' ')
    vars['TAGS'] = vars['tags']
      .collect { |tag| tag_layout.substitute({ tag: tag }) }
      .join(' ')

    post_layout.substitute(vars)
  end

vars = Blog.merge_vars({})
vars['CONTENT'] = posts.join("\n")

layout = File.read('layouts/index.html')
content = layout.substitute(vars)

File.open('out/index.html', 'wb') { |f| f.print(content) }

puts "\n. wrote out/index.html"

