abstract class Ast::Statement
  # abstract def type : Type
  abstract def exports : Array(Ast::Statement)?
  abstract def export_name : Ast::Identifier?
end

require "./expression"
require "./assignment"
require "./declaration/*"
require "./control-flow/*"
