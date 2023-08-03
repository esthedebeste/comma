class ConditionalStatement
  property label : String
  property condition : Expression
  property body : Block
  property else_body : Block | Nil

  def initialize(@label, @condition, @body, @else_body)
  end
end
