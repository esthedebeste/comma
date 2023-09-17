class Ast::Statement::Conditional < Ast::Statement
  property label : Ast::Identifier
  property elifs : Array({condition: Ast::Expression, block: Ast::Statement::Block})
  property else_body : Ast::Statement::Block | Nil

  def initialize(@label, @elifs, @else_body)
  end

  def exports : Array(Ast::Statement)?
    exports = elifs[0][:block].exports
    if exports.nil? || exports.empty?
      return nil
    end
    elifs.each do |elif|
      block_exports = elif[:block].exports
      if block_exports.nil? || block_exports.empty?
        return nil
      end
      exports.reject! do |export|
        !(block_exports.any? do |block_export|
          block_export.export_name == export.export_name
        end)
      end
      if exports.nil? || exports.empty?
        return nil
      end
    end
    exports
  end

  def export_name : Ast::Identifier?
    nil
  end
end
