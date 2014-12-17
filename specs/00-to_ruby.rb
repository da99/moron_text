
describe ":to_ruby" do

  it "returns an array describing the test" do
    o = Moron_Text.new(<<-EOF)
      MENU : My Title

      This is a menu to get input.

      (o) Option 1.
      (o) Option 2.
      (x) Option 3.
    EOF

    o.to_ruby.should == [
      {:type=>:command, :value=>'MENU', :arg=>'My Title'},
      {:type=>:text,    :value=>"This is a menu to get input."},
      {:type=>:command, :value=>'(o)',  :arg=>'Option 1.'},
      {:type=>:command, :value=>'(o)',  :arg=>'Option 2.'},
      {:type=>:command, :value=>'(x)',  :arg=>'Option 3.'},
    ]
  end

end # === describe ":to_ruby"
