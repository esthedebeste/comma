class CastExpression < Expression
  property casted : Expression
  property type : Type

  def initialize(@casted, @type)
  end

  def cppify : String
    "(#{type.cppify}) (#{casted.cppify})"
  end
end
