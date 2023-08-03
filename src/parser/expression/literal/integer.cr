class IntegerLiteralExpression < Expression
  property value : Int64

  def initialize(@value)
  end

  def cppify : String
    @value.to_s
  end
end
