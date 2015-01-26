
describe :grab_prev_text do

  it "pops the previous text" do
    o = Moron_Text.new(<<-EOF)
      This is text.
      BIRD /*
        Whistle
    EOF

    sounds = []
    o.run { |name, line, moron|
      if name == 'BIRD'
        sounds << moron.grab_prev_text
      else
        moron.typo!
      end
    }
    sounds.should == ['This is text.']
  end

  it "pops multiple lines of text" do
    o = Moron_Text.new(<<-EOF)
     This is one line.

     This is another line.
     DUCK /*

    EOF

    txt = nil
    o.run { |name, line, moron|
      if name == 'DUCK'
        txt = moron.grab_prev_text
      else
        moron.typo!
      end
    }
    trim(txt).should == trim(<<-EOF)
       This is one line.

       This is another line.
    EOF
  end

end # === describe :text
