require "../../expression"

class VariableDeclaration < Statement
  property name : String
  property type : Type
  property value : Expression

  def initialize(@name, @type, @value)
  end

  def cppify : String
    "#{@type} #{@name.cppify} = #{@value};"
  end
end
