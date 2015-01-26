
describe :return do

  it "concats arguments to stack" do
    m = Moron_Text.new(<<-EOF)
      MENU /* 1
      MENU /* 2
      MENU /* 3
    EOF

    m.run { |name, line, moron| moron.return line[:arg] }
    m.stack.should == '1 2 3'.split
  end # === it adds value to stack

  it "prevents the rest of the block or lambda from executing" do
    m = Moron_Text.new(<<-EOF)
      MENU /* 4
      MENU /* 5
      MENU /* 6
    EOF

    m.run { |name, line, moron|
      moron.return line[:arg]
      fail
    }

    m.stack.should == '4 5 6'.split
  end # === it prevents the rest of the block or lambda from executing

  it "does not alter the stack if no arguments are passed to it" do
    m = Moron_Text.new(<<-EOF)
      MENU /* 4
      MENU /* 5
      MENU /* 6
    EOF

    m.run { |name, line, moron| moron.return }

    m.stack.should == []
  end # === it does not alter the stack if no arguments are passed to it

end # === describe :return
