# Logical inverter!
require 'rubygems'
require 'ruby2ruby'

class Sexp
  def to_ruby
    Ruby2Ruby.new.process(self)
  end

  def invert_logic
    Sexp.from_array(self.map do |op|
      case op
        when :or
          :and
        when :and
          :or
        else
          if op.is_a? Sexp
            case op.first
              when :not
                op.last.invert_logic
              when :const
                Sexp.for("!#{op.to_ruby}")
              else
                op.invert_logic
            end
          else
            op
          end
      end
    end.compact)
  end
end

if $0 == __FILE__
puts "SEXP STYLE"
puts Sexp.for("(A or B)").invert_logic.to_ruby
end
