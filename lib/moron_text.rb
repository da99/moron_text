
class Moron_Text

  CMD_WITH_ARG = /\s*(.+)\s+:\s+(.+)/
  UI_ELEMENT   = /\s*([\(\[].[\)\]])\s+(.+)/

  class << self
  end # === class self ===

  def initialize str
    @str = str
  end # === def initialize

  def to_ruby

    # === Pass 1
    @str.each_line.inject([]) { |memo, line|

      if line =~ CMD_WITH_ARG
        memo << {:type=>:command, :value=>$1, :arg=>$2}
      elsif line =~ UI_ELEMENT
        memo << {:type=>:command, :value=>$1, :arg=>$2}
      else
        if memo.last && memo.last[:type]==:text
          memo.last[:value] << line
        else
          memo << {:type=>:text, :value=>line}
        end
      end

      memo

    # === PASS 2
    }.map { |o|
      if o[:type]==:text
        o[:value] = o[:value].strip
      end

      o
    }

  end # === def to_ruby

end # === class Moron_Text ===
