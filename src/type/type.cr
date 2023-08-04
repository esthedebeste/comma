abstract class Type
  abstract def cppify : String

  def to_s(io : IO) : Nil
    io << cppify
  end
end

class BuiltinType < Type
  property token : BuiltinTypeToken

  def initialize(@token : BuiltinTypeToken)
  end

  def cppify : String
    @token.cppify
  end
end
