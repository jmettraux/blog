
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
require 'redcarpet/render_strip'


class String

  def substitute(vars)

    self.gsub(/\$\{[^\}]+\}/) do |dollar|

      d = dollar[2..-2]

      r = (vars.instance_eval('self.' + d) rescue nil)
      next r.to_s if r

      r = (vars.instance_eval(d) rescue nil)
      next r.to_s if r

      ''
    end
  end
end

class Hash

  def partial(path) # helper

    File.read(File.join('partials/', path)).substitute(self)
  end

  def method_missing(key, *args, &block)

    return super if args.any? || block

    self[key.to_s] || self[key]
  end
end

class Array

  def method_missing(key, *args, &block)

    return super if args.any? || block

    i = key.to_s.to_i
    return super if i.to_s != key.to_s

    self[i]
  end
end

module Blog

  @html_renderer =
    Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new({}),
      {})
  @text_renderer =
    Redcarpet::Markdown.new(
      Redcarpet::Render::StripDown.new(),
      {})

  def self.md_render(s, opts={})

    renderer = opts[:mode] == 'text' ? @text_renderer : @html_renderer

    r = renderer.render(s)

    if opts[:index] == true
      r = r.gsub(/\s*<\/?blockquote>\s*/, '"')
    end

    r
  end

  def self.load_post(path)

    content = File.read(path).strip
    m = content.match(/\A---\n(.*)\n---\n(.*)\z/m)

    vars = merge_vars(m ? m[1] : {})
    content = m ? m[2].strip : content

    m = content.match(/\A## ([^\n]+)/)

    vars['title'] ||= m ? m[1] : ''
    vars['_title'] = vars['title'].gsub(/[^a-zA-Z0-9]/, '_')
    vars['id'] = File.basename(path, '.md')
    vars['tags'] ||= []

    [ vars, content ]
  end

  def self.merge_vars(o)

    (YAML.load(File.read('blog.yaml')) rescue {})
      .merge(o.is_a?(Hash) ? o : YAML.load(o))
  end
end

