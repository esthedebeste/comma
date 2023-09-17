require "../block"

class Ast::Statement::FunctionDeclaration < Ast::Statement
  property name : Ast::Identifier
  property parameters : Array({name: Ast::Identifier, type: Type})
  property block : Ast::Statement::Block
  property returns : Type

  def initialize(@name : Ast::Identifier, @parameters, @block, @returns)
  end

  def last_declared_variable(curr : Ast::Statement::Block = @block) : Ast::Statement::VariableDeclaration | Nil
    curr.statements.reverse_each do |statement|
      if statement.is_a?(Ast::Statement::VariableDeclaration)
        return statement
      end
    end
    nil
  end

  def exported? : Bool
    name.exported?
  end

  def exports : Array(Ast::Statement)?
    if exported?
      return [self.as(Ast::Statement)]
    end
    nil
  end

  def export_name : Ast::Identifier?
    if exported?
      return name
    end
    nil
  end
end
