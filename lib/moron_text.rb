
class Moron_Text


  PATTERNS = {
    :command__arg__closed => /\A\s*(.+)\s+:\s+(.+)\s+\.\s?\Z/,
    :command__arg         => /\A\s*(.+)\s+:\s+(.+)\Z/,
    :command__closed      => /\A\s*(.+)\s+\.\s*\Z/,
    :command              => /\A\s*(.+)\s+:\s*\Z/,
    :ui_element           => /\A\s*([\(\[].[\)\]])\s+(.+)\Z/,
    :text                 => nil,

    :on => {
      :command    => lambda { |info, match| info[:type] = :command; info[:value] = match[1] },
      :arg        => lambda { |info, match| info[:arg] = match[2] },
      :closed     => lambda { |info, match| info[:is_closed] = true },
      :ui_element => lambda { |info, match| info },
      :text       => lambda { |info, line, last| 
        if last
          last[:value] << "\n".freeze
          last[:value] << line
        end
      }
    }
  }

  PATTERNS[:keys] = PATTERNS.keys.inject({}) { |memo, key|
    memo[key] = key.to_s.split('__'.freeze).map(&:to_sym)
    memo
  }


  NEW_LINE_REG_EXP = /\r?\n/
  TYPO             = Class.new(RuntimeError) do
    attr_reader :moron
    def initialize moron, text = "Typo"
      super text
      @moron = moron
    end

    def line_number
      @moron.line_number
    end

    def line_context
      start = line_number - 3 - 1
      stop  = line_number + 3 - 1
      start = 0 if start < 0
      moron.lines.slice(start, stop - start).map { |o|
        [o[:line_number], o[:original]]
      }
    end
  end # === Class.new

  MISSING_KEY  = lambda { |hash, key|
    fail RuntimeError, "Missing key: #{key.inspect}"
  }

  class << self
  end # === class self ===

  attr_reader :lines, :stack, :defs

  def initialize str
    @str           = str
    @lines         = nil
    @stack         = nil
    @has_run       = false
    @defs          = {}
    @current_index = nil
    @next_index    = nil
  end # === def initialize

  def typo msg
    TYPO.new(self, msg)
  end

  def line_number
    current[:line_number]
  end

  def current
    @lines[@current_index]
  end

  def text
    next_ = lines[@next_index]
    unless next_ && next_[:type] == :text
      fail typo("Missing text for line.")
    end

    @next_index += 1
    next_[:value]
  end

  def split
    current[:arg].split
  end

  def numbers
    split.map { |u|
      begin
        Float(u)
      rescue ArguementError
        fail typo("Numerical typo.")
      end
    }
  end

  def run
    return @stack if @has_run

    parse
    @stack         = []
    @current_index = 0
    stop_at        = lines.size

    while @current_index < stop_at
      @next_index = @current_index + 1
      o = current
      case o[:type]
      when :text
        o
      when :command
        def_ = @defs[o[:value]]
        fail(typo "Not found: #{o[:value]}") unless def_
        val = def_.call(self)
        (@stack << val) if val != :ignore
      else
        fail "Programmer error: #{o[:type].inspect}"
      end
      @current_index = @next_index
    end

    @has_run = true
    @stack
  end

  def def name, l
    @defs[name.split.map(&:upcase).join ' '] = l
  end

  def parse
    return @lines if @lines

    lines       = @str.strip.split(NEW_LINE_REG_EXP)
    line_number = 0
    meta        = lambda { |type, val|
      {:type=>type, :value=>val, :original=>lines[line_number-1], :line_number=>line_number, :is_closed=>false, :arg=>nil}
    }

    @lines ||= lines.inject([]) { |memo, line|
      # === Pass 1: Create an array of commands and text.

      line_number += 1
      info = nil

      PATTERNS.detect { |name, pattern|
        if pattern
          the_match = line.match pattern
          next unless the_match

          info = meta.call(:command, nil)
          PATTERNS[:keys][name].each { |prop|
            PATTERNS[:on][prop].call(info, the_match)
          }
        else
          if memo.last[:type] == name
            PATTERNS[:on][name].call meta, line, memo.last
          else
            info = meta.call(name, line)
            PATTERNS[:on][name].call info, line, nil
          end
        end
        memo << info if info
        true
      }

      memo.last.default_proc = MISSING_KEY
      memo

    }.map { |o|
      # === PASS 2: strip all text

      if o[:type]==:text
        o[:value] = o[:value].strip
      end

      o
    }

  end # === def parse

end # === class Moron_Text ===
