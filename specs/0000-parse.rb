
describe ":parse" do

  it "returns an array describing the text" do
    o = Moron_Text.new(<<-EOF)
      MENU : My Title
      This is some text.
      MENU2 : arg arg .
      MENU3 .
      More text
      content.
    EOF

    o.parse.map { |line| 
      line.values_at(:type, :value, :arg, :is_closed)
    }.should == [
      [:command, 'MENU',                      'My Title', false],
      [:text,    "This is some text.",        nil, false],
      [:command, 'MENU2',                     'arg arg', true],
      [:command, 'MENU3',                     nil, true],
      [:text,    "More text\n      content.", nil, false]
    ]
  end

  it "parses the following as a command: CMD :" do
    o = Moron_Text.new(<<-EOF)
      CMD :
        some text
    EOF

    o.parse.map { |line|
      line[:type]
    }.should == [:command, :text]
  end

end # === describe ":parse"
