
describe ":run" do

  it "runs the text as code" do
    o = Moron_Text.new(<<-EOF)
      ADD /* 1 2 3
      SUBTRACT /* 100 5 5
    EOF

    o.def 'ADD', lambda { |moron|
      moron.numbers.reduce(:+)
    }

    o.def 'SUBTRACT', lambda { |moron|
      moron.numbers.reduce(:-)
    }

    o.run
    o.stack.should == [6, 90]
  end

end # === describe ":run"
