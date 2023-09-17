class Ast::Expression::FloatLiteral < Ast::Expression
  property value : Float64

  def initialize(@value : Float64)
  end
end
