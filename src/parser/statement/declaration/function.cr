require "../block"

def find_last_declared_variable(curr : Block) : VariableDeclaration | Nil
  curr.statements.reverse_each do |statement|
    if statement.is_a?(VariableDeclaration)
      return statement
    end
  end
  nil
end

class FunctionDeclaration < Statement
  property name : String
  property parameters : Array({name: String, type: Type})
  property block : Block
  property returns : Type

  def initialize(@name, @parameters, @block, @returns)
  end

  def cppify : String
    last_declared = find_last_declared_variable block
    if last_declared.nil?
      # undefined behavior
      ret = "puts(\":3\");exit(123);"
    else
      ret = "return #{last_declared.name.cppify};"
    end
    "auto #{@name.cppify} = [](#{@parameters.map { |p| "#{p[:type]} #{p[:name].cppify}" }.join ", "}) -> #{@returns} {\n#{@block}\n#{ret}\n};"
  end
end
