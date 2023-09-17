class Ast::Statement::NotAgain < Ast::Statement
  property endname : Ast::Identifier

  def initialize(@endname : Ast::Identifier)
  end

  def exports : Array(Ast::Statement)?
    nil
  end

  def export_name : Ast::Identifier?
    nil
  end
end
