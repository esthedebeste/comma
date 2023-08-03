require "../../type"

abstract class Expression
  abstract def cppify : String
  # abstract def type : Type
end

require "./call"
require "./binop"
require "./variable"
require "./literal/*"
