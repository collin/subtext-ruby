module SubText
  class Node
    attr_accessor :input, :parent, :children, :assertion, :root, :table
    
    def initialize input, assertion
      raise "Assertion can only be true/false!" unless [true, false].include? assertion
      @input = input    
      @assertion = assertion
      @children = []
    end
    
    def unflattened_all_nodes
      children + map{|child| child.all_nodes}
    end
    
    def all_nodes
       unflattened_all_nodes.flatten
    end
    
    def all_ids
      all_nodes.map{|node| node.id }
    end
    
    def id
      "#{parent_id}#{self_id}"
    end
    
    def self_id
      return "/" if root?
      "#{input.name}/#{assertion}"
    end
    
    def root?
      root.object_id == self.object_id
    end
    
    def table
      return @table if root?
      root.table
    end
    
    def parent_id
      return "" if parent.nil?
      "#{parent.id}"
    end

    def == other
      self.id == other.id
    end

    def empty?
      children.empty?
    end
    
    def gaps
      (instance_gaps + children.map{|child| child.gaps }).flatten.uniq
    end
    
    def instance_gaps
      NodeSet.new(table.inputs.map { |input| 
        [Node.new(input.last, true), Node.new(input.last, false)]
      }.flatten) - (parent_ids << id)
  #    []
    end
    
    def parent_ids
      ids = [parent_id]
      ids += parent.parent_ids unless parent.nil?
      ids
    end
    
    def overlaps
      []
    end
    
    def inspect
      "#<Node #{id}>"
    end
    
    alias to_s inspect

    def map &block
      children.map &block
    end
    
    def append input, assertion
      node = Node.new input, assertion
      node.parent = self
      node.root = self if self.root?
      children << node
      node
    end
  end
end
