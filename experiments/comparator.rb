require 'set'
class TermClass
  attr_accessor :name
  def initialize name
    @name = name.to_s
  end
  
  def == other
    name == other.name
  end
  
  def inspect
    @name
  end
  
  def satisfies?(proposition)
    proposition.include?(self)
  end
  
  def to_s
    @name
  end
end

class NotClass
  def initialize(expression)
    @expression = expression
  end
  
  def == other
    case other
    when NotClass
      expression == other.expression
    when TermClass
      false
    end
  end
  
  def to_s
    "~#{expression}"
  end
  alias inspect to_s
  
  def expression
    @expression
  end
  
  def satisfies?(proposition)
    not(@expression.satisfies?(proposition))
  end
end

class LogicOperatorClass
  attr_reader :left, :right, :set
  
  def to_s
   "(#{left} #{symbol} #{right})"
  end
  alias inspect to_s
  
  def == other
    (left == other.left && right == other.right) || (right == other.left && left == other.right)
    
    # set == other.set
  end
  
  def initialize left, right
    @left, @right = left, right
    @set = Set.new [@left, @right]
  end
  
  def satisfies?(proposition)
    raise "Implemente satisfies? in a concrete LogicOperatorClass"
  end
end 

class DisjunctClass < LogicOperatorClass
  def symbol; :or end
  
  def satisfies?(proposition)
    @left.satisfies?(proposition) or @right.satisfies?(proposition)
  end
end

class ConjunctClass < LogicOperatorClass
  def symbol; :and end
  
  def satisfies?(proposition)
    @left.satisfies?(proposition) and @right.satisfies?(proposition)
  end
end

class TableClass
  attr_reader :columns
  def initialize(inputs, outputs)
    @inputs, @outputs, @columns = inputs, outputs, []
  end
  
  def add_column column
    column.table = self
    @columns << column
  end
  
  def gaps
    propositions = potential
    columns.each do |column|
      propositions.reject! { |proposition| column.satisfies?(proposition) }
    end
    propositions
  end
  
  def overlaps
    overlaps = {}
    columns.each do |column|
      column.satisfied_propositions.each do |prop|
        overlaps[prop.inspect] ||= []; 
        overlaps[prop.inspect] << prop
      end
    end
    overlaps.reject { |key, value| true if value.length == 1}
  end
  
  def columns_matching_proposition(proposition)
    
  end

  def potential
    potential = Set.new
    (@inputs.size**2).times do |step|
      potent = []
      @inputs.each_with_index do |input, index| 
        potent << if step[index] == 0
          Not(@inputs[index])
        else
          @inputs[index]
        end
      end
      potential.add potent
    end
    potential
  end
  
  def to_s
    "<#Table of #{@inputs.join(", ")}
  #{columns.join("\n  ")}
  
  Potential #{potential.inspect}
  Gaps      #{gaps.inspect}
  Overlaps  #{overlaps.inspect}
>"
  end
end

# (A and B) <- what does this satisfy
#   (A or B), (A or ~B), (A and B), (~A or B) <- ding ding ding

class ColumnClass
  attr_reader :outputs
  attr_accessor :table
  
  def initialize(expression, outputs)
    @expression, @outputs = expression, outputs
  end
    
  # proposition is one of the potential set of inputs for this table
  def satisfies?(proposition)
    @expression.satisfies?(proposition)
  end
  
  def satisfied_propositions()
    Set.new @table.potential.find_all do |proposition| 
      satisfies?(proposition) 
    end.map do |satisfied| 
      Set.new satisfied
    end
  end
  
  def to_s
    "<#Column #{@expression} #{outputs.inspect} Satisfies: #{satisfied_propositions.inspect}>"
  end
end

def Term(*args); TermClass.new(*args) end
def Not(*args); NotClass.new(*args) end
def Or(*args); DisjunctClass.new(*args) end
def And(*args); ConjunctClass.new(*args) end
def Table(*args); TableClass.new(*args) end
def Column(*args); ColumnClass.new(*args) end

if $0 == __FILE__
A = Term :A
B = Term :B
C = Term :C
X = Term :X

table = Table [A, B], [X]
column1 = Column Or(A, B), X => 11
column2 = Column And(B, A), X => 22
column3 = Column And(Not(A), Not(B)), X => 33
column4 = Column Or(A, Not(B)), X => 44
table.add_column column1
table.add_column column2
table.add_column column3
table.add_column column4

puts table; puts

end