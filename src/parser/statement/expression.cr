require "../expression"

class ExpressionStatement < Statement
  property expression : Expression

  def initialize(@expression)
  end

  def cppify : String
    "#{@expression};"
  end
end
