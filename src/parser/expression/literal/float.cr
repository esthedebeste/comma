class FloatLiteralExpression < Expression
  property value : Float64

  def initialize(@value)
  end

  def cppify : String
    @value.to_s
  end
end
