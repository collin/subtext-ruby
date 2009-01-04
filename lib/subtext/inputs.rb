module SubText
  class Inputs
    def initialize
      @inputs = {}
    end

    def [] name
      @inputs[name]
    end

    def names
      @inputs.keys
    end

    def map &block
      @inputs.map &block
    end

    def << name
      raise "Cannot have two inputs with the same name, fool!" if names.include? name
      input = Input.new(name)  
      @inputs[name] = input
      input
    end
  end
end
