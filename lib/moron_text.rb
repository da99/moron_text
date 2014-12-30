
class Moron_Text

  CMD_WITH_ARG = /\s*(.+)\s+:\s+(.+)/
  CMD_NO_ARG   = /\s*(.+)\s+\.\s*/
  UI_ELEMENT   = /\s*([\(\[].[\)\]])\s+(.+)/
  TYPO         = Class.new(RuntimeError)

  class << self
  end # === class self ===

  attr_reader :lines, :stack, :current

  def initialize str
    @str   = str
    @lines = nil
    @stack = nil
    @has_run=false
    @defs  = {}
    @current = nil
  end # === def initialize

  def numbers
    current[:arg].split.map { |u|
      begin
        Float(u)
      rescue ArguementError
        raise(Moron_Text::TYPO, "Numerical typo: #{txt}")
      end
    }
  end

  def run
    return @stack if @has_run

    parse
    @stack = []
    lines.each { |o|
      @current = o
      case o[:type]
      when :text
        o
      when :command
        def_ = @defs[o[:value]]
        fail(Moron_Text::TYPO, o[:original]) unless def_
        val = def_.call(self)
        (@stack << val) if val != :ignore
      else
        fail "Programmer error: #{o[:type].inspect}"
      end
    }

    @has_run = true
    @stack
  end

  def def name, l
    @defs[name.split.map(&:upcase).join ' '] = l
  end

  def parse
    return @lines if @lines

    # === Pass 1
    @lines ||= @str.each_line.inject([]) { |memo, line|

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

      memo.last[:original] = line
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
