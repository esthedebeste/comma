class Ast::Expression::Variable < Ast::Expression
  property name : Ast::Identifier

  def initialize(@name : Ast::Identifier)
  end
end
