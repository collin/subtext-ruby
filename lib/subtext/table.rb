module SubText
  class Table
    @@input_names = []
    
    attr_accessor :inputs, :root
    
    def initialize
      @inputs = Inputs.new
      @root = Node.new Input.new(:root), true
      @root.root = @root
      @root.table = self
    end  
    
    def inspect
      "#<Table #{root.all_ids}>"
    end
    
    def append *args
      root.append *args
    end
    
    def gaps   
      set = if root.empty?
        []
      else
        root.gaps
      end
      GapSet.new set
    end
    
    def overlaps
      set = if root.empty?
        []
      else
        root.overlaps
      end
      OverlapSet.new set
    end
    
    def [] *args
      inputs.[] *args
    end
    
    alias to_s inspect
  end
end
