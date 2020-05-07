class TrieNode
  attr_reader :parent
  attr_accessor :has_value

  def initialize(parent=nil)
    @parent = parent
    @children = {}
    @has_value = false
  end

  def has_child?(ch)
    @children.include?(ch)
  end

  def add_child!(ch)
    @children[ch] = TrieNode.new self
  end

  def get_child(ch)
    @children[ch]
  end

  def self.get_root
    self.new
  end

  def print(level=0)
    puts "#{' ' * level}#{@has_value}, #{@children.keys}\n"
    @children.each do |k, v|
      v.print level + 1
    end
  end
end

class Trie
  def initialize
    @root = TrieNode.get_root
  end

  def insert! s
    curr_node = @root
    s.each_char do |ch|
      if not curr_node.has_child? ch
        curr_node.add_child! ch
      end
      curr_node = curr_node.get_child ch
    end
    curr_node.has_value = true
  end

  def find s
    curr_node = @root
    s.each_char do |ch|
      if not curr_node.has_child? ch
        return false
      end
      curr_node = curr_node.get_child ch
    end
    curr_node.has_value
  end
end