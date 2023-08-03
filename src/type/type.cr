abstract class Type
  abstract def to_cpp : String
end

class BuiltinType < Type
  property token : BuiltinTypeToken

  def initialize(@token : BuiltinTypeToken)
  end

  def to_cpp : String
    @token.to_cpp
  end
end
