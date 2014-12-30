
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

end # === describe :text
