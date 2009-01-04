module SubText
  class NodeSet
    def initialize nodes
      @nodes = nodes
    end
    
    def inspect
      "#<#{self.class.name} [#{@nodes.map{|node| node.inspect }.join(', ')}]>"
    end
    
    def + nodeset
      @nodes += nodeset.instance_variable_get :@nodes
    end
    
    def - nodes
      @nodes = @nodes.reject do |node|
        nodes.include? node.id
      end
    end
    
    alias to_s inspect
  end
end
