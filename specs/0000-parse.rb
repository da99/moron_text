
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
      l = line.dup
      l.delete :original
      l
    }.should == [
      {:type=>:command, :value=>'MENU', :arg=>'My Title', :closed=>false},
      {:type=>:text,    :value=>"This is some text."},
      {:type=>:command, :value=>'MENU2', :arg=>'arg arg', :closed=>true},
      {:type=>:command, :value=>'MENU3',  :closed=>true},
      {:type=>:text,    :value=>"More text\n      content."}
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
