def f; false end
def t; true end

def nand left, right
  not (left && right)
end

def _not term
  nand term, term
end

def _and left, right
  memo = nand left, right
  nand memo, memo
end

def _or left, right
  nand _not(left), _not(right)
end

def Nand left, right
  _not _and(left, right)
end

def Not(term)
  Nand(term, term)
end

def And(left, right)
  memo = Nand(left, right)
  Nand(memo, memo)
end

def Or(left, right)
  Nand( Not(left), Not(right )
end