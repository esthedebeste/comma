require "../lexer"
require "../ast/program"

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
  @curr_conditional : String | Nil

  def initialize(lexer : Lexer)
    @statements = statements lexer
  end

  def parse
    statements = [] of Ast::Statement
    while (statement = @statements.next)
      break if statement.is_a?(Iterator::Stop)
      statements << parse_statement statement
    end
    Ast::Program.new statements
  end

  def parse_block(endblock : String) : Ast::Statement::Block
    statements = [] of Ast::Statement
    while (statement = @statements.next)
      if statement.is_a?(Iterator::Stop)
        raise "Unexpected end of input, expected #{endblock} to close #{endblock.reverse}."
      end
      ender = statement.peek(1).as?(Identifier)
      break if statement.peek == Keyword::DOT && !ender.nil? && endblock == ender.name
      statements << parse_statement statement
    end
    Ast::Statement::Block.new(statements)
  end

  def parse_statement(tokens : PeekableReverseIteratorOverArray(Token))
    case token = tokens.next # skip the statement type
    when Keyword::DOT
      parse_dotty tokens
    when Keyword::QUESTION
      parse_conditionally tokens
    when Keyword::BANG
      parse_bangy tokens
    else
      raise "Unknown statement type: #{token} in #{tokens}"
    end
  end

  def parse_dotty(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement
    statement = tokens.try { parse_variable_declaration(tokens) } ||
                tokens.try { parse_assignment(tokens) } ||
                tokens.try { parse_function_declaration(tokens) } ||
                tokens.try { parse_expression_statement(tokens) }
    raise "Unknown dotty statement: #{tokens.inspect}" if statement.nil?
    statement
  end

  def parse_variable_declaration(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement | Nil
    expression = parse_expression tokens
    debu! expression
    return nil if expression.nil?
    debu! tokens.peek
    return nil if tokens.next != Keyword::EQUALS
    type = parse_type tokens
    debu! type
    return nil if type.nil?
    identifier = tokens.next.as?(Identifier)
    debu! identifier
    return nil if identifier.nil?
    return nil if !tokens.done
    debu! tokens
    Ast::Statement::VariableDeclaration.new Ast::Identifier.new(identifier.name), type, expression
  end

  def parse_assignment(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement | Nil
    expression = parse_expression tokens
    debu! expression
    return nil if expression.nil?
    return nil if tokens.next != Keyword::COMMA_EQUALS
    identifier = tokens.next.as?(Identifier)
    debu! identifier
    return nil if identifier.nil?
    return nil if !tokens.done
    debu! tokens
    Ast::Statement::Assignment.new Ast::Identifier.new(identifier.name), expression
  end

  def parse_function_declaration(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement | Nil
    returns = parse_type tokens
    debu! returns, tokens
    return nil if returns.nil?
    return nil if tokens.next != Keyword::TO
    parameters = [] of {name: Ast::Identifier, type: Type}
    while true
      type = parse_type tokens
      debu! type
      return nil if type.nil?
      identifier = tokens.next.as?(Identifier)
      debu! identifier
      return nil if identifier.nil?
      parameters << {name: Ast::Identifier.new(identifier.name), type: type}
      break if tokens.peek != Keyword::COMMA
      tokens.next
    end
    identifier = tokens.next.as?(Identifier)
    debu! identifier
    return nil if identifier.nil?
    return nil if !tokens.done
    block = parse_block identifier.name.reverse
    return nil if block.nil?
    Ast::Statement::FunctionDeclaration.new Ast::Identifier.new(identifier.name), parameters.reverse!, block, returns
  end

  def parse_conditionally(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement
    label = tokens.last.as?(Identifier)
    raise "Expected label for conditional" if label.nil?
    tokens = tokens.without_last
    debu! tokens
    condition = parse_expression tokens
    raise "Expected condition" if condition.nil?
    raise "Expected nothing before condition" if !tokens.done
    endblock = label.name.reverse
    elifs = [{condition: condition, block: Ast::Statement::Block.new [] of Ast::Statement}] of {condition: Ast::Expression, block: Ast::Statement::Block}
    else_block = nil
    curr : Ast::Statement::Block = elifs[0][:block]
    while (statement = @statements.next)
      raise "Unexpected end of input, expected #{endblock} to close #{endblock.reverse}." if statement.is_a?(Iterator::Stop)
      break if statement.size == 2 && statement.peek == Keyword::DOT && statement.peek(1).as?(Identifier).try &.name == endblock
      if statement.last == Keyword::COLON
        statement = statement.without_last # remove the colon
        if statement.peek == Keyword::QUESTION
          # :<condition>?
          statement.next
          condition = parse_expression statement
          raise "Expected condition in :?" if condition.nil?
          raise "Expected nothing after condition in :?" if !statement.done
          elif = {condition: condition, block: Ast::Statement::Block.new [] of Ast::Statement}
          elifs << elif
          curr = elif[:block]
          next
        else
          # : a ,= a minus 1.
          raise "Only 1 else block allowed" if !else_block.nil?
          else_block = Ast::Statement::Block.new [] of Ast::Statement
          curr = else_block
        end
      end
      @curr_conditional = label.name
      curr.statements << parse_statement statement
    end
    Ast::Statement::Conditional.new Ast::Identifier.new(label.name), elifs, else_block
  end

  def parse_bangy(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement
    token = tokens.next
    raise "Expected bangy statement" if token.nil?
    label = tokens.next.as?(Identifier).try(&.name) || @curr_conditional
    raise "Expected nothing after bangy keyword" if !tokens.done
    raise "Can't use `again` or `not again` outside of a conditional" if label.nil?
    case token
    when Keyword::AGAIN
      Ast::Statement::Again.new Ast::Identifier.new label
    when Keyword::NOT_AGAIN
      Ast::Statement::NotAgain.new Ast::Identifier.new label.reverse
    else
      raise "Unknown bangy statement: #{tokens}"
    end
  end

  def parse_expression_statement(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Statement | Nil
    expression = parse_expression tokens
    debu! "pes", expression
    return nil if expression.nil?
    return nil if !tokens.done
    Ast::Statement::Expression.new expression
  end

  def parse_expression(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    parse_binop(tokens)
  end

  # -> two double
  def parse_cast(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    type = parse_type tokens
    debu! type
    return nil if type.nil?
    value = parse_binop tokens
    debu! value
    return nil if value.nil?
    return nil if tokens.next != Keyword::THIN_ARROW
    Ast::Expression::Cast.new value, type
  end

  def parse_binop_argument(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    tokens.try { parse_literal(tokens) } ||
      tokens.try { parse_cast(tokens) } ||
      tokens.try { parse_function_call(tokens) } ||
      tokens.try { parse_variable(tokens) }
  end

  # 2, 3 double, 4 print
  # a + b + c doubled^
  def parse_function_call(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    debu! "call"
    identifier = tokens.next.as?(Identifier)
    return nil if identifier.nil?
    arguments = [] of Ast::Expression
    while true
      argument = parse_binop(tokens)
      debu! arguments
      return nil if argument.nil?
      arguments << argument
      break if tokens.peek != Keyword::COMMA
      tokens.next
    end
    Ast::Expression::Call.new(Ast::Expression::Variable.new(Ast::Identifier.new(identifier.name)), arguments.reverse!)
  end

  def parse_variable(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    identifier = tokens.next.as?(Identifier)
    debu! identifier
    return nil if identifier.nil?
    Ast::Expression::Variable.new Ast::Identifier.new identifier.name
  end

  def parse_literal(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    literal = tokens.next
    debu! literal
    case literal
    when IntegerLiteral
      Ast::Expression::IntegerLiteral.new literal.value
    when FloatLiteral
      Ast::Expression::FloatLiteral.new literal.value
    when ChanceLiteral
      Ast::Expression::ChanceLiteral.new literal.value, literal.runtime
    when StringLiteral
      Ast::Expression::StringLiteral.new literal.value
    when CharLiteral
      Ast::Expression::CharLiteral.new literal.value
    else
      nil
    end
  end

  # ^ is cursor
  # if first: "a + b + c doubled^"
  # if second: "a + b^ + c doubled" and "a^ + b + c doubled"
  def parse_binop(tokens : PeekableReverseIteratorOverArray(Token)) : Ast::Expression | Nil
    debu! "binop"
    second = parse_binop_argument(tokens)
    debu! second
    return nil if second.nil?
    operator = tokens.peek.as?(BinaryOperator)
    debu! operator
    return second if operator.nil?
    tokens.next
    first = parse_binop tokens
    return nil if first.nil?
    debu! first, operator, second
    Ast::Expression::Binop.new first, operator, second
  end

  def parse_type(tokens : PeekableReverseIteratorOverArray(Token)) : Type | Nil
    debu! tokens.peek
    type = tokens.next.as?(BuiltinTypeToken)
    return nil if type.nil?
    BuiltinType.new type
  end
end
