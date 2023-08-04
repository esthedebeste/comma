class BinopExpression < Expression
  # `X` in X divided by Y
  property first : Expression
  # `divided by` in X divided by Y
  property operator : BinaryOperator
  # `Y` in X divided by Y
  property second : Expression

  def initialize(@first, @operator, @second)
  end

  def cppify : String
    operator.cppify first.cppify, second.cppify
  end
end
