
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


class String

  def substitute(vars)

    self.gsub(/\$\{[^\}]+\}/) do |dollar|
      d = dollar[2..-2]
      Blog.var_lookup(vars, d.split('.')) || (Kernel.eval(d) rescue '')
    end
  end
end

module Blog

  def self.extract_vars(content)

    content = content.strip
    m = content.match(/\A---\n(.*)\n---\n(.*)\z/m)

    m ? [ YAML.load(m[1]), m[2].strip ] : [ {}, content ]
  end

  def self.var_lookup(start, keys)

    k = keys.shift

    return start unless k
    return start[k.to_i] if start.is_a?(Array)
    start[k]
  rescue
    nil
  end
end

