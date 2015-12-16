
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

layout = File.read('layout-index.html')

rd = Redcarpet::Render::HTML.new(rd_options)
md = Redcarpet::Markdown.new(rd, md_extensions)

vars = {}
posts = []

Dir['posts/*.md'].each do |path|

  print " #{path}"

  vars, content = Blog.extract_vars(File.read(path))
  content = content.strip[0, 140]
  posts << md.render(content.substitute(vars))
end

vars['CONTENT'] = posts.join("\n")
content = layout.substitute(vars)

File.open('out/index.html', 'wb') do |f|
  f.print(content)
end

puts "\n. wrote out/index.html"
