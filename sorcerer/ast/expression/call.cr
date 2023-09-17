class Ast::Expression::Call < Ast::Expression
  property callee : Ast::Expression
  property arguments : Array(Ast::Expression)

  def initialize(@callee : Ast::Expression, @arguments : Array(Ast::Expression))
  end
end
