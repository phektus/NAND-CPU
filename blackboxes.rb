load "components.rb"
load "blackbox.rb"

BlackBox.new(:AND, 2,1) do |i|
  n1 = n(i[0],i[1])
  n(n1,n1)
end

BlackBox.new(:NOT, 1,1) do |i|
  n(i[0],i[0])
end

BlackBox.new(:YES, 1, 1) do |i|
  NOT(NOT(i[0]))
end

BlackBox.new(:OR, 2,1) do |i|
  n(NOT(i[0]), NOT(i[1]))
end

BlackBox.new(:XOR, 2, 1) do |i|
  n1 = n(i[0],i[1])
  n2 = n(i[0],n1)
  n3 = n(i[1],n1)
  n(n2,n3)
end

BlackBox.new(:ThreeAND, 3, 1) do |i|
  AndG(AndG(i[0],i[1]), i[2])
end

BlackBox.new(:Clock, 0, 1) do |i|
  n1 = NAND.new 1, 0
  n1.r = w(n1)
  n1
end

BlackBox.new(:SRLatch, 2, 2) do |i|
  n1 = n(i[0],0)
  n2 = n(w(n1), i[1])
  n1.r = w(n2)
  [n1, n2]
end

BlackBox.new(:HalfAdder, 2, 2) do |i|
  [XOR(i[0], i[1]), AND(i[0],i[1])]
end

BlackBox.new(:FullAdder, 3, 2) do |i|
  ha1 = HalfAdder i[0], i[1]
  ha2 = HalfAdder ha1[0], i[2]
  [ha2[0], OR(ha1[1], ha2[1])]
end

BlackBox.new(:RippleCarryAdder, 8, 5) do |i|
  a1 = HalfAdder i[0], i[4]
  a2 = FullAdder i[1], i[5], a1[1]
  a3 = FullAdder i[2], i[6], a2[1]
  a4 = FullAdder i[3], i[7], a3[1]
  [a1[0], a2[0], a3[0], a4[0], a4[1]]
end
