class LogicExpression
  attr_accessor :negated
  alias inspect to_s
  alias negated? negated
  
  def invert; self end
  
  def negate
    @negated = (not @negated)
    self
  end
  
  def negation str=''
    negated ? "!#{str}" : str
  end
end

class Term < LogicExpression
  attr_accessor :name
  def initialize name
    @name = name.to_s
  end
  
  def to_s
    negation(@name)
  end
  alias inspect to_s
end

class LogicOperator
  attr_accessor :left, :right
  alias inspect to_s
  
  def to_s
   "#{left.to_s} #{symbol} #{right.to_s}"
  end
  
  def initialize left, right
    @left, @right = left, right
  end
  
  def invert
    opposition.new left, right
  end
  
  def negate
    opposition.new left.negate, right.negate
  end
end 

class Disjunct < LogicOperator
  def symbol; :or end
  def opposition; Conjunct end
end

class Conjunct < LogicOperator
  def symbol; :and end
  def opposition; Disjunct end
end

if $0 == __FILE__
puts "\nALGEBRA STYLE\n"
A = Term.new :A
B = Term.new :B
a_and_b = Conjunct.new A, B
puts a_and_b
not_a_and_b = a_and_b.negate
puts not_a_and_b
puts not_a_and_b.negate
puts a_and_b.invert.negate
end
