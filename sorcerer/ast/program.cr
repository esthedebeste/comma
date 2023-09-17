require "./identifier"
require "./statement"

class Ast::Program
  property statements : Array(Ast::Statement)

  def initialize(@statements : Array(Ast::Statement))
  end

  def export_names : Set(String)
    exports = Set.new
    @statements.each do |statement|
      export = statement.export_names
      if export
        exports.concat export
      end
    end
  end

  def exports : Array(Ast::Statement)
    exports = @statements.flat_map do |statement|
      statement.exports
    end.compact
  end
end
