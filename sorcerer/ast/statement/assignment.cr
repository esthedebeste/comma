class Ast::Statement::Assignment < Ast::Statement
  property name : Ast::Identifier
  property value : Ast::Expression

  def initialize(@name, @value)
  end

  def exports : Array(Ast::Statement)?
    nil
  end

  def export_name : Ast::Identifier?
    nil
  end
end
