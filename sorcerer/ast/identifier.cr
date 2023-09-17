struct Ast::Identifier
  property string : String

  def initialize(@string : String)
  end

  def reverse : Ast::Identifier
    Ast::Identifier.new(@string.reverse)
  end

  def exported? : Bool
    string.starts_with? '_'
  end
end

class String
  def ast_identifier : Ast::Identifier
    Ast::Identifier.new(self)
  end
end
