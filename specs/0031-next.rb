
describe :next do

  it "runs the given lambda if called from the :run block" do
    m = Moron_Text.new(<<-EOF)
      COMM 1 /* 1
      COMM 2 /* 1
    EOF

    stack = []
    l = lambda { |name, line, moron| stack << :lambda }
    m.run(l) { |name, line, moron| stack << :block; moron.next }
    stack.should == [:block, :lambda, :block, :lambda]
  end

  it "runs the given Class :run block if called from the instance :run lambda" do
    stack = []
    c = Class.new(Moron_Text)
    c.run { |name, line, moron| stack << :class }
    o = c.new(<<-EOF)
      COMM 3 /* 2
      COMM 4 /* 2
    EOF
    l = lambda { |name, line, moron| stack << :lambda; moron.next }
    o.run(l)
    stack.should == [:lambda, :class, :lambda, :class]
  end

  it "runs the given Class :run block if called from: instance :run lambda and block" do
    stack = []
    c = Class.new(Moron_Text)
    c.run { |name, line, moron| stack << :class }
    o = c.new(<<-EOF)
      COMM 5 /* 3
      COMM 6 /* 3
    EOF
    l = lambda { |name, line, moron| stack << :lambda; moron.next }
    o.run(l) { |name, line, moron| stack << :block; moron.next }
    stack.should == [:block, :lambda, :class, :block, :lambda, :class]
  end

end # === describe :next
