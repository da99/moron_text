
require "about_pos"

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
      :allow, 
      [
        [:on, [:radio_menu],     :value, ['( )', '(o)']],
        [:on, [:check_box_menu], :value, ['[ ]', '[x]']]
      ],
      :value,
      :grab_all_text
    ]
  }

  NEW_LINE_REG_EXP = /\r?\n/
  NL               = "\n".freeze
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
  end # === Class TYPO

  MISSING_KEY  = lambda { |hash, key|
    fail RuntimeError, "Missing key: #{key.inspect}"
  }

  class << self
  end # === class self ===

  attr_reader :lines, :parsed_lines, :stack, :defs

  def initialize str
    @str                = str
    @lines              = nil
    @parsed_lines       = nil
    @stack              = nil
    @has_run            = false
    @defs               = {}
    @line_number        = nil
    @parsed_line_number = nil
    @next_parse_line    = nil
    @settings           = {}
    @settings.default_proc = MISSING_KEY
  end # === def initialize

  def turn_on sym
    @settings[sym] = true
  end

  def turn_off sym
    @settings[sym] = false
  end

  def on? sym
    if !@settings.has_key?(sym)
      @settings[sym] = false
    end

    if @settings[sym] !== true && @settings[sym] !== false
      fail "Invalid type for: #{sym.inspect}: #{settings[sym].inspect}"
    end

    @settings[sym]
  end

  def off? sym
    if !@settings.has_key?(sym)
      @settings[sym] = false
    end

    !on?[sym]
  end

  def []= k, v
    @settings[k] = v
  end

  def [] k
    @settings[k]
  end

  def typo msg
    TYPO.new(self, msg)
  end

  def line_number
    current[:line_number]
  end

  def current
    @parsed_lines[@parsed_line_number]
  end

  def grab_text
    val = text
    @seq.grab
    val
  end

  def text
    fail typo("Missing text for line.") unless @seq.next?

    next_ = @seq.next.value
    fail typo("Missing text for line.")  unless next_[:type] == :text

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

  def fulfills? cond
    parsed = current
    About_Pos.Forward(cond).all? { |v,i,m|
      args = m.grab
      case v
      when :on
        args.any? { |on_name| on?(on_name) }
      when :value
        args.any? { |v| parsed[:value] == v }
      else
        fail "Typo: #{v.inspect}"
      end
    }
  end

  def run
    return @stack if @has_run

    parse
    @stack       = []
    @line_number = 0

    About_Pos.Forward(@parsed_lines) { |line, i, m|
      @parsed_line_number = i
      @seq = m
      case line[:type]

      when :text
        line

      when :command
        if line.has_key?(:grab_all_text)
          line[:text] = [
            (line.has_key?(:text)                    ? line[:text]    : nil),
            (m.next? && m.next.value[:type] == :text ? m.grab[:value] : nil)
          ].
          compact.
          join(NL)
        end

        if line.has_key?(:allow)
          case
          when line[:allow].all? { |c| c.is_a?(Array) }
            line[:allow].detect { |cond,i,m| fulfills? cond }
          else
            fulfills? line[:allow]
          end
        end

        def_ = @defs[line[:value]]
        fail(typo "Not found: #{line[:value]}") unless def_
        val = def_.call(self)
        (@stack << val) if val != :ignore

      else
        fail "Programmer error: #{line[:type].inspect}"

      end # case line[:type]
    }

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

    @lines       = @str.split(NEW_LINE_REG_EXP)
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
        while step < (stop-1)
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
            parsed[:text] = captures.compact.join ' '.freeze

          else
            fail "Typo: unknown pattern command: #{val.inspect}"

          end # case val
        end # while step < stop

        match
      } # detect if is command?

      if !is_command
        parsed = meta_line(:text, line.dup)
      end

      parsed.default_proc = MISSING_KEY
      @parsed_lines << parsed

    }

    # === PASS 2: combine text, strip it
    lines = []
    About_Pos.Forward(@parsed_lines) { |o, i, m|
      if o[:type] == :text
        while m.next? && m.next.value[:type] == :text
          o[:value] << NL
          o[:value] << m.grab[:value]
        end
        o[:value].strip! 
      end
      lines << o
    }

    @parsed_lines = lines
  end # === def parse

end # === class Moron_Text ===
