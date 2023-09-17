require "../../expression"

class Ast::Statement::VariableDeclaration < Ast::Statement
  property name : Ast::Identifier
  property type : Type
  property value : Ast::Expression

  def initialize(@name, @type, @value)
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
