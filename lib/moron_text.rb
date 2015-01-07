
class Moron_Text

  PATTERNS = {
    :command__arg__closed => [
      /\A\s*(.+)\s+:\s+(.+)\s+\.\s?\Z/,
      :value, :arg, :is_closed
    ],

    :command__arg         => [
      /\A\s*(.+)\s+:\s+(.+)\Z/,
      :value, :arg
    ],

    :command__closed      => [
      /\A\s*(.+)\s+\.\s*\Z/,
      :value, :is_closed
    ],

    :command              => [
      /\A\s*(.+)\s+:\s*\Z/,
      :value
    ],

    :ui_element           => [
      /\A\s*([\(\[].[\)\]])\s+(.+)\Z/,
      :allow, [:radio_menu,     '( )', '(o)'],
      :allow, [:check_box_menu, '[ ]', '[x]'],
      :value,
      :grab_all_text
    ]
  }

  NEW_LINE_REG_EXP = /\r?\n/
  TYPO             = Class.new(RuntimeError) do

    attr_reader :moron, :line_number

    def initialize moron, text = "Typo"
      super text
      @moron = moron
      @line_number = @moron.line_number
    end

    def line
      moron.lines[line_number-1]
    end

    def line_context
      start = line_number - 3 - 1
      stop  = line_number + 3 - 1
      start = 0 if start < 0
      i = start
      moron.lines.slice(start, stop - start).map { |o|
        i += 1
        [i, o]
      }
    end
  end # === Class.new

  MISSING_KEY  = lambda { |hash, key|
    fail RuntimeError, "Missing key: #{key.inspect}"
  }

  class << self
  end # === class self ===

  attr_reader :lines, :parsed_lines, :stack, :defs

  def initialize str
    @str               = str
    @lines             = nil
    @parsed_lines      = nil
    @stack             = nil
    @has_run           = false
    @defs              = {}
    @line_number       = nil
    @parse_line_number = nil
    @next_parse_line   = nil
    @settings          = {}
  end # === def initialize

  def turn_on sym
    @settings[sym] = true
  end

  def turn_off sym
    @settings[sym] = false
  end

  def on? sym
    !!@settings[sym]
  end

  def off? sym
    !on?[sym]
  end

  def typo msg
    TYPO.new(self, msg)
  end

  def line_number
    current[:line_number]
  end

  def current
    @parsed_lines[@parse_line_number]
  end

  def text
    next_ = @parsed_lines[@next_parse_line]
    unless next_ && next_[:type] == :text
      fail typo("Missing text for line.")
    end

    @next_parse_line += 1
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

    @stack             = []
    @line_number       = 0
    @parse_line_number = 0
    stop_at            = parsed_lines.size

    while @parse_line_number < stop_at

      @next_parse_line = @parse_line_number + 1
      o = current

      case o[:type]

      when :text
        o

      when :command

        if o.has_key?(:allow)
          fail
        end

        if o.has_key?(:grab_all_text)
          fail
        end

        def_ = @defs[o[:value]]
        fail(typo "Not found: #{o[:value]}") unless def_
        val = def_.call(self)
        (@stack << val) if val != :ignore

      else
        fail "Programmer error: #{o[:type].inspect}"

      end # case o[:type]

      @parse_line_number = @next_parse_line

    end # while

    @has_run = true
    @stack
  end

  def def name, l
    @defs[name.split.map(&:upcase).join ' '] = l
  end

  def meta_line type, val
    {
      :type        =>type,
      :value       =>val,
      :original    =>@lines[@parse_index-1],
      :line_number =>@parse_index,
      :is_closed   =>false,
      :arg         =>nil
    }
  end

  def treat_as name, line
    if @parsed_lines.last[:type] == name
      o = @parsed_lines.last
      result = PATTERNS[:on][name].call self, line, o
    else
      o = meta_line(name, line)
      result = PATTERNS[:on][name].call o, line, nil
    end
    result
  end

  def parse
    return @parsed_lines if @parsed_lines

    @lines       = @str.strip.split(NEW_LINE_REG_EXP)
    @parse_index = 0

    @parsed_lines = []

    # === Pass 1: Create an array of commands and text.
    @lines.each { |line|

      @parse_index += 1
      parsed = nil

      is_command = PATTERNS.detect { |name, pattern|
        match = line.match pattern.first
        next unless match
        captures = match.captures
        shift_capture = lambda {
          fail "Captures already empty: #{name.inspect}" if captures.empty?
          captures.shift
        }
        parsed = meta_line(:command, nil)
        start = 0
        step  = start
        stop  = pattern.size
        capture_i = 0
        while step < stop
          grab_next = lambda {
            step += 1
            fail("No more items.") if step >= stop
            pattern[step]
          }

          val = grab_next.call
          next if step == start

          case val

          when :value
            parsed[:value] = shift_capture.call

          when :arg
            parsed[:arg] = shift_capture.call

          when :is_closed
            parsed[:is_closed] = true

          when :allow
            parsed[:allow] = grab_next.call

          when :grab_all_text
            parsed[:grab_all_text] = true
            parsed[:arg] = ([parsed[:arg]] +  captures).compact.join ' '.freeze

          else
            fail "Typo: unknown pattern command: #{val.inspect}"

          end # case val
        end # while step < stop

        match
      } # detect if is command?

      if !is_command
        parsed = meta_line(:text, line)
      end

      parsed.default_proc = MISSING_KEY
      @parsed_lines << parsed

    }

    # === PASS 2: strip all text
    @parsed_lines.each_index { |i|
      o = @parsed_lines[i]
      o[:value].strip! if o[:type] == :text
    }

    @parsed_lines
  end # === def parse

end # === class Moron_Text ===
