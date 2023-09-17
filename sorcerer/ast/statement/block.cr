class Ast::Statement::Block < Ast::Statement
  property statements : Array(Ast::Statement)

  def initialize(@statements : Array(Ast::Statement))
  end

  def exports : Array(Ast::Statement)?
    exports = Array(Ast::Statement).new
    @statements.flat_map do |statement|
      statement.exports
    end.compact
  end

  def export_name : Ast::Identifier?
    nil
  end
end
