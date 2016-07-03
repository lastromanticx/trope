class Treap
  attr_accessor :value, :size, :left, :right
  attr_reader :key

  def initialize(value=nil)
    @value = value
    @key = rand(0..2**32)
    @size = 1
  end

  def self.size(treap)
    if treap then treap.size else 0 end
  end

  def self.update(treap)
    if treap
      treap.size = 1 + self.size(treap.left) + self.size(treap.right)
    end
    
    treap
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

  def self.split(treap,i)
    if not treap then return [self.new, self.new] end
    if i <= self.size(treap.left)
      u, treap.left = self.split(treap.left, i)
      [u, self.update(treap)]
    else
     treap.right, u = self.split(treap.right, i - self.size(treap.left) - 1)
      [self.update(treap), u]
    end
  end

  def self.insert(treap, i, value)
    left, right = self.split(treap,i)

    u = self.new(value)
    self.merge(self.merge(left,u), right)
  end

  def self.erase(treap,i)
    left, right = self.split(treap,i + 1)
    left, u = self.split(left, i)
    [self.merge(left,right), u]
  end
end
