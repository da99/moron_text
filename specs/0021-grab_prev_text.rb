
describe :grab_prev_text do

  it "pops the previous text" do
    o = Moron_Text.new(<<-EOF)
      This is text.
      BIRD /*
        Whistle
    EOF

    sounds = []
    o.def 'BIRD', lambda { |moron| sounds << moron.grab_prev_text }
    o.run
    sounds.should == ['This is text.']
  end

  it "pops multiple lines of text" do
    o = Moron_Text.new(<<-EOF)
     This is one line.

     This is another line.
     DUCK /*

    EOF

    txt = nil
    o.def 'DUCK', lambda { |moron| txt = moron.grab_prev_text }
    o.run
    trim(txt).should == trim(<<-EOF)
       This is one line.

       This is another line.
    EOF
  end

end # === describe :text
