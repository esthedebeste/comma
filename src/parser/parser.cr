require "../lexer"
require "./program"

def statements(lexer : Lexer) : Iterator(PeekableReverseIteratorOverArray(Token))
  curr = [] of Token
  lexer.each.compact_map do |token|
    curr << token
    case token
    when Keyword::DOT, Keyword::QUESTION, Keyword::BANG
      statement = curr
      curr = [] of Token
      PeekableReverseIteratorOverArray.new statement
    else
      nil
    end
  end
end

class Parser
  property statements : Iterator(PeekableReverseIteratorOverArray(Token))

  def initialize(lexer : Lexer)
    @statements = statements lexer
  end

  def parse
    while (statement = @statements.next)
      break if statement.is_a?(Iterator::Stop)
      parse_statement statement
    end
  end

  def parse_block(endblock : Array(String)) : {Block, String}
    statements = [] of Statement
    while (statement = @statements.next)
      if statement.is_a?(Iterator::Stop)
        raise "Unexpected end of input, expected #{endblock} to close #{endblock.reverse}."
      end
      ender = statement.peek(1).as?(Identifier)
      break if statement.peek == Keyword::DOT && !ender.nil? && endblock.includes?(ender.name)
      statements << parse_statement statement
    end
    {Block.new(statements), ender.not_nil!.name}
  end

  def parse_statement(tokens : PeekableReverseIteratorOverArray(Token))
    p! case tokens.next # skip the statement type
    when Keyword::DOT
      parse_dotty tokens
    when Keyword::QUESTION
      parse_conditionally tokens
    when Keyword::BANG
      parse_bangy tokens
    else
      raise "Unknown statement: #{tokens}"
    end
  end

  def parse_dotty(tokens : PeekableReverseIteratorOverArray(Token)) : Statement
    statement = tokens.try { |t| parse_variable_declaration(t) } ||
                tokens.try { |t| parse_function_declaration(t) } ||
                tokens.try { |t| parse_expression_statement(t) }
    raise "Unknown statement: #{tokens.to_s}" if statement.nil?
    statement
  end

  def parse_variable_declaration(tokens : PeekableReverseIteratorOverArray(Token)) : Statement | Nil
    expression = parse_expression tokens
    p! expression
    return nil if expression.nil?
    return nil if tokens.next != Keyword::EQUALS
    type = parse_type tokens
    p! type
    return nil if type.nil?
    identifier = tokens.next.as?(Identifier)
    p! identifier
    return nil if identifier.nil?
    return nil if !tokens.done
    p! tokens
    VariableDeclaration.new identifier.name, type, expression
  end

  def parse_function_declaration(tokens : PeekableReverseIteratorOverArray(Token)) : Statement | Nil
    type = parse_type tokens
    p! "fn", type
    return nil if type.nil?
    return nil if tokens.next != Keyword::TO
    parameters = [] of {name: String, type: Type}
    while true
      type = parse_type tokens
      p! type
      return nil if type.nil?
      identifier = tokens.next.as?(Identifier)
      p! identifier
      return nil if identifier.nil?
      parameters << {name: identifier.name, type: type}
      break if tokens.peek != Keyword::COMMA
      tokens.next
    end
    identifier = tokens.next.as?(Identifier)
    p! identifier
    return nil if identifier.nil?
    return nil if !tokens.done
    block, _ = parse_block [identifier.name.reverse]
    return nil if block.nil?
    FunctionDeclaration.new identifier.name, parameters, block
  end

  def parse_conditionally(tokens : PeekableReverseIteratorOverArray(Token)) : Statement
    condition = parse_expression tokens
    raise "Expected condition" if condition.nil?
    label = tokens.next.as?(Identifier)
    raise "Expected label for conditional" if label.nil?
    raise "Expected nothing before conditional label" if !tokens.done
    block, closer = parse_block [label.name.reverse, "else"]
    raise "Expected block" if block.nil?
    if closer == "else"
      else_block, _ = parse_block [label.name.reverse]
      raise "Expected else block" if else_block.nil?
    end
    ConditionalStatement.new label.name, condition, block, else_block
  end

  def parse_bangy(tokens : PeekableReverseIteratorOverArray(Token)) : Statement
    token = tokens.next
    raise "Expected bangy statement" if token.nil?
    raise "Expected nothing after bangy keyword" if !tokens.done
    case token
    when Keyword::AGAIN
      AgainStatement.new
    when Keyword::NOT_AGAIN
      NotAgainStatement.new
    else
      raise "Unknown bangy statement: #{tokens}"
    end
  end

  def parse_expression_statement(tokens : PeekableReverseIteratorOverArray(Token)) : Statement | Nil
    expression = parse_expression tokens
    return nil if expression.nil?
    return nil if !tokens.done
    ExpressionStatement.new expression
  end

  def parse_expression(tokens : PeekableReverseIteratorOverArray(Token)) : Expression | Nil
    tokens.try { |t| parse_function_call(t) } ||
      tokens.try { |t| parse_function_call_argument(t) }
  end

  def parse_function_call_argument(tokens : PeekableReverseIteratorOverArray(Token)) : Expression | Nil
    tokens.try { |t| parse_variable(t) } ||
      tokens.try { |t| parse_literal(t) } ||
      tokens.try { |t| parse_binop(t) }
  end

  # print 1, double 2, 3
  def parse_function_call(tokens : PeekableReverseIteratorOverArray(Token), last_argument : Expression | Nil = nil) : Expression | Nil
    arguments = [] of Expression
    while true
      argument = parse_function_call_argument(tokens)
      return nil if argument.nil?
      arguments << argument
      break if tokens.next != Keyword::COMMA
    end
    identifier = tokens.next.as?(Identifier)
    return nil if identifier.nil?
    parse_function_call_post_last(tokens, CallExpression.new(VariableExpression.new(identifier.name), arguments))
  end

  # print 1, <last_argument>
  def parse_function_call_post_last(tokens : PeekableReverseIteratorOverArray(Token), last_argument : Expression | Nil = nil) : Expression | Nil
    arguments = [last_argument] of Expression
    while tokens.peek == Keyword::COMMA
      tokens.next
      argument = parse_function_call_argument(tokens)
      return nil if argument.nil?
      arguments << argument
    end
    identifier = tokens.next.as?(Identifier)
    return last_argument if identifier.nil? && arguments.size == 1 # no function call present
    return nil if identifier.nil?
    parse_function_call_post_last(tokens, CallExpression.new(VariableExpression.new(identifier.name), arguments))
  end

  def parse_variable(tokens : PeekableReverseIteratorOverArray(Token)) : Expression | Nil
    identifier = tokens.next.as?(Identifier)
    return nil if identifier.nil?
    VariableExpression.new identifier.name
  end

  def parse_literal(tokens : PeekableReverseIteratorOverArray(Token)) : Expression | Nil
    literal = tokens.next
    case literal
    when IntegerLiteral
      IntegerLiteralExpression.new literal.value
    when FloatLiteral
      FloatLiteralExpression.new literal.value
    when ChanceLiteral
      ChanceLiteralExpression.new literal.value
    when StringLiteral
      StringLiteralExpression.new literal.value
    when CharLiteral
      CharLiteralExpression.new literal.value
    else
      nil
    end
  end

  def parse_binop(tokens : PeekableReverseIteratorOverArray(Token)) : Expression | Nil
    left = parse_expression tokens
    return nil if left.nil?
    operator = tokens.next.as?(BinaryOperator)
    return nil if operator.nil?
    right = parse_expression tokens
    return nil if right.nil?
    BinopExpression.new left, operator, right
  end

  def parse_type(tokens : PeekableReverseIteratorOverArray(Token)) : Type | Nil
    p! tokens.peek
    type = tokens.next.as?(BuiltinTypeToken)
    return nil if type.nil?
    BuiltinType.new type
  end
end
