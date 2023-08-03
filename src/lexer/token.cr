enum Keyword
  COMMA
  DOT
  QUESTION
  BANG
  EQUALS
  COMMA_EQUALS
  TO
  AGAIN
  NOT_AGAIN
end

enum BinaryOperator
  GREATER
  LESS
  GREATER_EQUALS
  LESS_EQUALS
  PLUS
  MINUS
  DIFF
  TIMES
  DIVIDED_BY
  TO_THE_POWER_OF
  MODULO
end

enum BuiltinTypeToken
  SIGN
  SIGN_64
  SIGN_32
  UNSI
  UNSI_64
  UNSI_32
  MATH_SMALL
  MATH_BIG
  CHACHA
  TEXTTT

  def to_cpp
    case self
    when SIGN
      "ssize_t"
    when SIGN_64
      "int64_t"
    when SIGN_32
      "int32_t"
    when UNSI
      "size_t"
    when UNSI_64
      "uint64_t"
    when UNSI_32
      "uint32_t"
    when MATH_SMALL
      "float"
    when MATH_BIG
      "double"
    when CHACHA
      "char"
    when TEXTTT
      "std::string"
    end
  end
end

class Identifier
  property name : String

  def initialize(@name : String)
  end
end

class StringLiteral
  property value : String

  def initialize(@value : String)
  end
end

class IntegerLiteral
  property value : Int64

  def initialize(@value : Int64)
  end
end

class FloatLiteral
  property value : Float64

  def initialize(@value : Float64)
  end
end

class CharLiteral
  property value : Char

  def initialize(@value : Char)
  end
end

class ChanceLiteral
  property value : Float64

  def initialize(@value : Float64)
  end
end

Keywords = {
  ","         => Keyword::COMMA,
  "."         => Keyword::DOT,
  "="         => Keyword::EQUALS,
  ",="        => Keyword::COMMA_EQUALS,
  "?"         => Keyword::QUESTION,
  "to"        => Keyword::TO,
  "again"     => Keyword::AGAIN,
  "not again" => Keyword::NOT_AGAIN,

  ">"               => BinaryOperator::GREATER,
  "<"               => BinaryOperator::LESS,
  ">="              => BinaryOperator::GREATER_EQUALS,
  "<="              => BinaryOperator::LESS_EQUALS,
  "plus"            => BinaryOperator::PLUS,
  "minus"           => BinaryOperator::MINUS,
  "diff"            => BinaryOperator::DIFF,
  "times"           => BinaryOperator::TIMES,
  "divided by"      => BinaryOperator::DIVIDED_BY,
  "to the power of" => BinaryOperator::TO_THE_POWER_OF,
  "modulo"          => BinaryOperator::MODULO,

  "true"      => ChanceLiteral.new(1.0),
  "always"    => ChanceLiteral.new(1.0),
  "sometimes" => ChanceLiteral.new(0.5), # TODO: runtime
  "maybe"     => ChanceLiteral.new(0.5), # compile-time
  "false"     => ChanceLiteral.new(0.0),
  "never"     => ChanceLiteral.new(0.0),

  "sign"            => BuiltinTypeToken::SIGN,
  "sign sixty-four" => BuiltinTypeToken::SIGN_64,
  "sign thirty-two" => BuiltinTypeToken::SIGN_32,
  "unsi"            => BuiltinTypeToken::UNSI,
  "unsi sixty-four" => BuiltinTypeToken::UNSI_64,
  "unsi thirty-two" => BuiltinTypeToken::UNSI_32,
  "math small"      => BuiltinTypeToken::MATH_SMALL,
  "math big"        => BuiltinTypeToken::MATH_BIG,
  "chacha"          => BuiltinTypeToken::CHACHA,
  "texttt"          => BuiltinTypeToken::TEXTTT,

  "zero"      => IntegerLiteral.new(0),
  "one"       => IntegerLiteral.new(1),
  "two"       => IntegerLiteral.new(2),
  "three"     => IntegerLiteral.new(3),
  "four"      => IntegerLiteral.new(4),
  "five"      => IntegerLiteral.new(5),
  "six"       => IntegerLiteral.new(6),
  "seven"     => IntegerLiteral.new(7),
  "nine"      => IntegerLiteral.new(9),
  "ten"       => IntegerLiteral.new(10),
  "a hundred" => IntegerLiteral.new(100),
}

KeywordsArray = Keywords.to_a.sort_by! { |k, v| -k.size }

alias Literal = StringLiteral | IntegerLiteral | FloatLiteral | CharLiteral | ChanceLiteral
alias Token = Keyword | BinaryOperator | BuiltinTypeToken | Identifier | Literal
