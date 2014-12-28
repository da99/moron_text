
describe ":parse" do

  it "returns an array describing the text" do
    o = Moron_Text.new(<<-EOF)
      MENU : My Title
      This is a menu to get input.
      SOME COMMAND .
      More text
      content.
    EOF

    o.parse.should == [
      {:type=>:command, :value=>'MENU', :arg=>'My Title'},
      {:type=>:text,    :value=>"This is a menu to get input."},
      {:type=>:command, :value=>'SOME COMMAND',  :closed=>true},
      {:type=>:text,    :value=>"More text\n      content."}
    ]
  end

end # === describe ":parse"
