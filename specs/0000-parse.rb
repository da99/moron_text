
describe ":parse" do

  it "returns an array describing the text" do
    o = Moron_Text.new(<<-EOF)
      MENU /* My Title
      This is some text.
      MENU2 /* arg arg
      MENU3 /*
      More text
      content.
    EOF

    o.parse.map { |line| 
      line.values_at(:type, :value, :arg)
    }.should == [
      [:command, 'MENU',                      'My Title'],
      [:text,    "This is some text.",        nil],
      [:command, 'MENU2',                     'arg arg'],
      [:command, 'MENU3',                     nil],
      [:text,    "More text\n      content.", nil]
    ]
  end

  it "parses the following as a command: CMD :" do
    o = Moron_Text.new(<<-EOF)
      CMD /*
        some text
    EOF

    o.parse.map { |line|
      line[:type]
    }.should == [:command, :text]
  end

end # === describe ":parse"
