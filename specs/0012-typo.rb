
describe :typo do

  it "raises a TYPO" do
    o = Moron_Text.new(<<-EOF)
      DUCK /* a
        Quack
    EOF

    lambda {
      o.run do |name, line, moron|
        fail moron.typo('blah') if name == 'DUCK'
        :typo
      end
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

    lambda {
      o.run do |name, line, moron|
        case name
        when 'GOOSE'
          "done"
        when 'DUCK'
          fail moron.typo('blah 1')
        else
          :typo
        end
      end
    }.
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

    lambda {
      o.run do |name, line, moron|
        case name
        when 'GOOSE'
          "done"
        when 'DUCK'
          fail moron.typo('blah 2')
        else
          :typo
        end
      end
    }.
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

    lambda {
      o.run do |name, line, moron|
        case name
        when 'GOOSE'
          "done"
        when 'DUCK'
          fail moron.typo('blah 3')
        else
          :typo
        end
      end
    }.
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
