class Ast::Statement::Again < Ast::Statement
  property start : Ast::Identifier

  def initialize(@start : Ast::Identifier)
  end

  def exports : Array(Ast::Statement)?
    nil
  end

  def export_name : Ast::Identifier?
    nil
  end
end
