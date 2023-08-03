class ChanceLiteralExpression < Expression
  property chance : Float64

  def initialize(@chance)
  end

  def cppify : String
    rand < chance ? "true" : "false"
  end
end
