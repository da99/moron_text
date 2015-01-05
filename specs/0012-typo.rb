
describe :typo do

  it "raises a TYPO" do
    o = Moron_Text.new(<<-EOF)
      DUCK : a
        Quack
    EOF
    o.def 'DUCK', lambda { |moron| moron.typo('blah') }

    lambda {
      o.run
    }.should.raise(Moron_Text::TYPO).
    message.should.match /blah/
  end

end # === describe :typo
