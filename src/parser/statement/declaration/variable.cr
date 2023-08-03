require "../../expression"

class VariableDeclaration
  property name : String
  property type : Type
  property value : Expression

  def initialize(@name, @type, @value)
  end
end
