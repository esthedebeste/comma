class CharLiteralExpression < Expression
  property value : Char

  def initialize(@value)
  end

  def cppify : String
    "'#{@value}'"
  end
end
