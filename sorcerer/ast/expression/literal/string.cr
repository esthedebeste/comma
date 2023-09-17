class Ast::Expression::StringLiteral < Ast::Expression
  property value : String

  def initialize(@value : String)
  end
end
