
describe :text do

  it "pops the following text" do
    o = Moron_Text.new(<<-EOF)
      DUCK :
        QUACK
      BIRD :
        Whistle
    EOF

    sounds = []
    o.def 'DUCK', lambda { |moron| sounds << moron.text }
    o.def 'BIRD', lambda { |moron| sounds << moron.text }
    o.run
    sounds.should == %w{ QUACK Whistle }
  end

  it "pops multiple lines of text" do
    o = Moron_Text.new(<<-EOF)
      DUCK :

       This is one line.

       This is another line.

    EOF

    txt = nil
    o.def 'DUCK', lambda { |moron| txt = moron.text }
    o.run
    txt.should == <<-EOF.strip
       This is one line.

       This is another line.
    EOF
  end

end # === describe :text
