
class Moron_Text

  CMD_WITH_ARG = /\s*(.+)\s+:\s+(.+)/
  CMD_NO_ARG   = /\s*(.+)\s+\.\s*/
  UI_ELEMENT   = /\s*([\(\[].[\)\]])\s+(.+)/

  class << self
  end # === class self ===

  def initialize str
    @str = str
  end # === def initialize

  def parse

    # === Pass 1
    @str.each_line.inject([]) { |memo, line|

      if line =~ CMD_WITH_ARG
        val       = $1
        arg       = $2.sub(/(\s+\.\s*\Z)/, '')
        is_closed = !!($1)
        memo << {:type=>:command, :value=>val, :arg=>arg, :closed=>is_closed}

      elsif line =~ CMD_NO_ARG
        memo << {:type=>:command, :value=>$1, :closed=>true}

      elsif line =~ UI_ELEMENT
        memo << {:type=>:command, :value=>$1, :arg=>$2}

      else
        if memo.last && memo.last[:type]==:text
          memo.last[:value] << line
        else
          memo << {:type=>:text, :value=>line}
        end

      end # === if

      memo

    # === PASS 2
    }.map { |o|
      if o[:type]==:text
        o[:value] = o[:value].strip
      end

      o
    }

  end # === def parse

end # === class Moron_Text ===
