abstract class Statement
  abstract def cppify : String

  # abstract def type : Type

  def to_s(io : IO) : Nil
    io << cppify
  end
end

require "./expression"
require "./assignment"
require "./declaration/*"
require "./control-flow/*"
