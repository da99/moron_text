
describe :grab_text do

  it "pops the following text" do
    o = Moron_Text.new(<<-EOF)
      DUCK /*
        QUACK
      BIRD /*
        Whistle
    EOF

    sounds = []
    o.run do |name, line, moron|
      case name
      when 'DUCK'
        sounds << moron.grab_text
      when 'BIRD'
        sounds << moron.grab_text
      else
        :typo
      end
    end
    sounds.should == %w{ QUACK Whistle }
  end

  it "pops multiple lines of text" do
    o = Moron_Text.new(<<-EOF)
      DUCK /*

       This is one line.

       This is another line.

    EOF

    txt = nil
    o.run { |name, line, moron|
      if name == 'DUCK'
        txt = moron.grab_text 
      else
        :typo
      end
    }
    txt.should == <<-EOF.strip
       This is one line.

       This is another line.
    EOF
  end

end # === describe :text
