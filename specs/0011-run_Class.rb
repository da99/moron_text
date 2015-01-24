
describe ":run Class" do

  it "runs given block on commands" do
    stack = []

    c = Class.new(Moron_Text)
    c.run { |name, line, moron|
      stack << [name, line[:arg]]
    }

    o = c.new(<<-EOF)
      BLADE_1 /* 1 2 3
      BLADE_2 /* 100 5 5
    EOF

    o.run

    stack.should == [
      ['BLADE_1', '1 2 3'],
      ['BLADE_2', '100 5 5'],
    ]
  end

end # === describe ":run Class"
