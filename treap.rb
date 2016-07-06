class T
  attr_accessor :value, :size, :left, :right
  attr_reader :key

  def initialize(value=nil)
    @value = value
    @key = rand(0..2**32)
    @size = 1
  end

  def self.size(t)
    if t then t.size else 0 end
  end

  def self.update(t)
    if t
      t.size = 1 + self.size(t.left) + self.size(t.right)
    end
    
    t
  end

  def self.merge(a,b)
    if not a then return b end
    if not b then return a end
    if a.key > b.key
      a.right = self.merge(a.right, b)
      self.update(a)
    else
      b.left = self.merge(a, b.left)
      self.update(b)
    end
  end

  def self.split(t,i)
    if not t then return [nil,nil] end
    if i <= self.size(t.left)
      u, t.left = self.split(t.left, i)
      [u, self.update(t)]
    else
     t.right, u = self.split(t.right, i - self.size(t.left) - 1)
      [self.update(t), u]
    end
  end

  def self.insert(t, i, value)
    left, right = self.split(t,i)

    u = self.new(value)
    self.merge(self.merge(left,u), right)
  end

  def self.erase(t,i)
    left, right = self.split(t,i + 1)
    left, u = self.split(left, i)
    [self.merge(left,right), u]
  end

 # shifts elements between [l,r] left to position i
  def self.shift_l t,l,r,i
    a,c = split t,r + 1
    a,lr = split a,l
    a,b = split a,i

    t = merge(merge(a,lr), merge(b,c))
    
    t
  end

 # shifts elements between [l,r] right to position i
  def self.shift_r t,l,r,i
    a,c = split t,l
    lr,c = split c,r - l + 1 
    b,c = split c,i - r + 1

    t = merge(merge(a,b), merge(lr,c))

    t
  end
end

class Traverse
  attr_accessor :tree
  attr_reader :in_order

  def initialize tree
    @tree = tree
    @in_order = []
    self.recurse_in_order tree
  end

  def recurse_in_order t
    if t.left
      recurse_in_order t.left
    end

    in_order << t.value

    if t.right
      recurse_in_order t.right
    end
  end
end
