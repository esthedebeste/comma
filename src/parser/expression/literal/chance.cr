class ChanceLiteralExpression < Expression
  property chance : Float64
  property runtime : Bool

  def initialize(@chance, @runtime = false)
  end

  def cppify : String
    if runtime
      return "::comma::Chance{#{chance}}"
    else
      rand < chance ? "true" : "false"
    end
  end
end
