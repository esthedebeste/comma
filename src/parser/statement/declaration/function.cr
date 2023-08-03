require "../block"

class FunctionDeclaration
  property name : String
  property parameters : Array({name: String, type: Type})
  property block : Block

  def initialize(@name, @parameters, @block)
  end
end
