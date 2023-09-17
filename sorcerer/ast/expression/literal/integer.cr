class Ast::Expression::IntegerLiteral < Ast::Expression
  property value : Int64

  def initialize(@value : Int64)
  end
end
