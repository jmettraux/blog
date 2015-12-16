
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

    m ? [ m[1], m[2] ] : [ '', content ]
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

