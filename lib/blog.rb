
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


class String

  def substitute(vars)

    self.gsub(/\$\{[^\}]+\}/) do |dollar|
      d = dollar[2..-2]
      Blog.var_lookup(vars, d.split('.')) || (vars.instance_eval(d) rescue '')
    end
  end
end

class Hash

  def partial(path)

    File.read(File.join('partials/', path)).substitute(self)
  end
end

module Blog

  rd_options = {}
  md_extensions = {}

  rd = Redcarpet::Render::HTML.new(rd_options)
  @md = Redcarpet::Markdown.new(rd, md_extensions)

  def self.md_render(s)

    @md.render(s)
  end

  def self.load_post(path)

    content = File.read(path).strip
    m = content.match(/\A---\n(.*)\n---\n(.*)\z/m)

    vars = merge_vars(m ? m[1] : {})
    content = m ? m[2].strip : content

    m = content.match(/\A## ([^\n]+)/)

    vars['title'] ||= m ? m[1] : ''
    vars['id'] = File.basename(path, '.md')

    [ vars, content ]
  end

  def self.merge_vars(o)

    (YAML.load(File.read('blog.yaml')) rescue {})
      .merge(o.is_a?(Hash) ? o : YAML.load(o))
  end

  def self.var_lookup(start, keys)

    k = keys.shift

    return start unless k
    var_lookup(start.is_a?(Array) ? start[k.to_i] : start[k], keys)

  rescue

    nil
  end
end

