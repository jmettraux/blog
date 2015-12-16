
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

require 'yaml'
require 'redcarpet'

rd_options = {}
md_extensions = {}

layout = File.read('layout.html')

rd = Redcarpet::Render::HTML.new(rd_options)
md = Redcarpet::Markdown.new(rd, md_extensions)

def extract_vars(content)

  content = content.strip
  m = content.match(/\A---\n(.*)\n---\n(.*)\z/m)

  m ? [ m[1], m[2] ] : [ '', content ]
end

def lookup(start, keys)

  k = keys.shift

  return start if k == nil
  lookup(start.is_a?(Array) ? start[k.to_i] : start[k], keys) rescue nil
end

class String

  def substitute(vars)

    self.gsub(/\$\{[^\}]+\}/) do |dollar|
      d = dollar[2..-2]
      lookup(vars, d.split('.')) || (Kernel.eval(d) rescue '')
    end
  end
end

Dir['posts/*.md'].each do |path|

  fn = 'out/' + File.basename(path, '.md') + '.html'

  File.open(fn, 'wb') { |f|

    vars, content = extract_vars(File.read(path))

    vars = YAML.load(vars)
    vars['CONTENT'] = content.substitute(vars)

    f.print(layout.substitute(vars))
  }

  puts ". wrote #{fn}"
end

