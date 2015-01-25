
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

  it "runs given block if instance :run block uses next" do
    stack = []

    c = Class.new(Moron_Text)
    c.run { |name, line, moron|
      stack << [name, line[:arg]]
    }

    o = c.new(<<-EOF)
      BLADE_1 /* 1
      BLADE_2 /* c
    EOF

    o.run { |name, line, moron|
      stack << "instance"
      :next
    }

    stack.should == [
      "instance",
      ['BLADE_1', '1'],
      "instance",
      ['BLADE_2', 'c'],
    ]
  end

end # === describe ":run Class"
