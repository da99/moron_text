
describe :typo do

  it "raises a TYPO" do
    o = Moron_Text.new(<<-EOF)
      DUCK /* a
        Quack
    EOF
    o.def 'DUCK', lambda { |moron| fail moron.typo('blah') }

    lambda {
      o.run
    }.should.raise(Moron_Text::TYPO).
    message.should.match /blah/
  end

  it "returns a TYPO with :line" do
    o = Moron_Text.new(trim <<-EOF)
      GOOSE /*
        Line 2
        Line 3
      DUCK /*
        Line 5
    EOF
    o.def 'GOOSE', lambda { |moron| "done" }
    o.def 'DUCK', lambda { |moron| fail moron.typo('blah 1') }

    lambda { o.run }.
      should.raise(Moron_Text::TYPO).
      line.should == 'DUCK /*'
  end

  it "returns a TYPO with :line_number" do
    o = Moron_Text.new(<<-EOF)
      GOOSE /*
        Line 2
        Line 3
      DUCK /*
        Line 5
    EOF
    o.def 'GOOSE', lambda { |moron| "done" }
    o.def 'DUCK', lambda { |moron| fail moron.typo('blah 2') }

    lambda { o.run }.
      should.raise(Moron_Text::TYPO).
      line_number.should == 4
  end # === it returns a TYPO with :line_number

  it 'returns a TYPO with :line_context' do
    o = Moron_Text.new(<<-EOF)
      GOOSE /*
        Line 2
        Line 3
      DUCK /*
        Line 5
    EOF
    space = '      '
    o.def 'GOOSE', lambda { |moron| "done" }
    o.def 'DUCK', lambda { |moron| fail moron.typo('blah 3') }

    lambda { o.run }.
      should.raise(Moron_Text::TYPO).
      line_context.should == [
        [1, "#{space}GOOSE /*"],
        [2, "#{space}  Line 2"],
        [3, "#{space}  Line 3"],
        [4, "#{space}DUCK /*"],
        [5, "#{space}  Line 5"]
      ]
  end

end # === describe :typo
