
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

require 'redcarpet'
require 'blog'

rd_options = {}
md_extensions = {}

rd = Redcarpet::Render::HTML.new(rd_options)
md = Redcarpet::Markdown.new(rd, md_extensions)

layout = File.read('layout-all-post.html')

posts =
  Dir['posts/*.md'].collect do |path|

    print " #{path}"

    vars, content = Blog.extract_vars(File.read(path))
    content = content.split("\n")[0, 3].join("\n") + "\n&hellip;"
    vars['id'] = File.basename(path, '.md')
    vars['CONTENT'] = md.render(content.substitute(vars))

    layout.substitute(vars)
  end

vars = {}
vars['CONTENT'] = posts.join("\n")

layout = File.read('layout-all.html')
content = layout.substitute(vars)

File.open('out/all.html', 'wb') { |f| f.print(content) }

puts "\n. wrote out/all.html"

