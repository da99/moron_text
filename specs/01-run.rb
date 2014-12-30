
describe ":run" do

  it "runs the text as code" do
    o = Moron_Text.new(<<-EOF)
      ADD : 1 2 3
      SUBTRACT : 100 5 5
    EOF

    o.def 'ADD', lambda { |moron, line|
      nums = moron.numbers line[:arg]
      nums.inject(0) { |memo, obj|
        memo + obj
      }
    }

    o.def 'SUBTRACT', lambda { |moron, line|
      nums = moron.numbers line[:arg]
      start = nums.shift
      nums.inject(start) { |memo, obj|
        memo - obj
      }
    }

    o.run
    o.stack.should == [6, 90]
  end

end # === describe ":run"
