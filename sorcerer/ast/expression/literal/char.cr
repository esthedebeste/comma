class Ast::Expression::CharLiteral < Ast::Expression
  property value : Char

  def initialize(@value : Char)
  end
end
