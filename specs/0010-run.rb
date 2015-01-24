
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
        :typo
      end
    end

    o.stack.should == [6, 90]
  end

end # === describe ":run"
