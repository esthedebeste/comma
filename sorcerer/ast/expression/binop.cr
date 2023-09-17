class Ast::Expression::Binop < Ast::Expression
  # `X` in X divided by Y
  property first : Ast::Expression
  # `divided by` in X divided by Y
  property operator : BinaryOperator
  # `Y` in X divided by Y
  property second : Ast::Expression

  def initialize(@first : Ast::Expression, @operator : BinaryOperator, @second : Ast::Expression)
  end
end
