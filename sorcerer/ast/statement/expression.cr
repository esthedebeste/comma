require "../expression"

class Ast::Statement::Expression < Ast::Statement
  property expression : Ast::Expression

  def initialize(@expression)
  end

  def exports : Array(Ast::Statement)?
    nil
  end

  def export_name : Ast::Identifier?
    nil
  end
end
