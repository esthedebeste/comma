class CallExpression < Expression
  property callee : Expression
  property arguments : Array(Expression)

  def initialize(@callee, @arguments)
  end

  def cppify : String
    "#{callee}(#{arguments.join(", ")})"
  end
end
