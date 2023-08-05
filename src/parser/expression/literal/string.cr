class StringLiteralExpression < Expression
  property value : String

  def initialize(@value)
  end

  def cppify : String
    "::comma::string(\"#{@value.gsub('\n', "\\n")}\")"
  end
end
