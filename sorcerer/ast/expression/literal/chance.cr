class Ast::Expression::ChanceLiteral < Ast::Expression
  property chance : Float64
  property runtime : Bool

  def initialize(@chance : Float64, @runtime : Bool = false)
  end
end
