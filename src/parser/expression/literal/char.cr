class CharLiteralExpression < Expression
  property value : String

  def initialize(@value)
  end

  def cppify : String
    "'#{@value}'"
  end
end
