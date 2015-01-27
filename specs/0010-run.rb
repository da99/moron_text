
describe :run do

  it "runs the text as code" do
    o = Moron_Text.new(<<-EOF)
      ADD /* 1 2 3
      SUBTRACT /* 100 5 5
    EOF

    o.run do |name, line, moron|
      case name
      when 'ADD'
        moron.numbers.reduce(:+)
      when 'SUBTRACT'
        moron.numbers.reduce(:-)
      else
        moron.next
      end
    end

    o.stack.should == [6, 90]
  end

  it "passes text to block" do
    o = Moron_Text.new(<<-EOF)
      COMM 1 /*

      This is text.

      COMM 2 /*

      This is more text.
    EOF

    stack = []
    o.run do |name, line, moron|
      stack << line[:value].strip
    end

    stack.should == [
      'COMM 1',
      'This is text.',
      'COMM 2',
      'This is more text.'
    ]
  end # === it passes text to block

end # === describe ":run"
