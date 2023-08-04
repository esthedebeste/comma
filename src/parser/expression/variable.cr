class VariableExpression < Expression
  property name : String

  def initialize(@name)
  end

  def cppify : String
    @name.cppify
  end
end
