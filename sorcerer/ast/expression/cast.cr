class Ast::Expression::Cast < Ast::Expression
  property casted : Ast::Expression
  property type : Type

  def initialize(@casted : Ast::Expression, @type : Type)
  end
end
