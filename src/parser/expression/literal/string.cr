class StringLiteralExpression < Expression
  property value : String

  def initialize(@value)
  end

  def cppify : String
    "::std::string(\"#{@value}\")"
  end
end
