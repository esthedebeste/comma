require "../../type"

abstract class Expression
  abstract def cppify : String

  # abstract def type : Type
  def to_s(io : IO) : Nil
    io << cppify
  end
end

require "./call"
require "./binop"
require "./variable"
require "./cast"
require "./literal/*"
