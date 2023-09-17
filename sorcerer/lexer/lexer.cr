require "./token"
require "../reader"

class Lexer
  property input : Reader
  property tokens : Array(Token) = [] of Token

  def initialize(@input)
  end

  def next_token : Token | Nil
    input.skip_whitespace
    if input.eof?
      return nil
    end
    KeywordsArray.each do |text, meaning|
      if input.skip text
        return meaning
      end
    end

    if input.peek.ascii_number?
      number = ""
      while input.peek.ascii_number?
        number += input.next
      end
      if / \d/ =~ input.peek(2)
        input.next
        number += "." # decimals
        while input.peek.ascii_number?
          number += input.next
        end
        return FloatLiteral.new(number.to_f)
      else
        return IntegerLiteral.new(number.to_i)
      end
    end

    if input.peek.identifier_start?
      identifier = ""
      while input.peek.identifier?
        identifier += input.next
      end
      return Identifier.new(identifier)
    end

    if input.peek == '"'
      input.next
      string = ""
      escape = 0
      while true
        char = input.next
        if char == '\\'
          escape += 1
        elsif char == '"' && escape % 2 == 0
          break
        else
          escape.times do
            string += "\\"
          end
          string += char
          escape = 0
        end
      end
      input.skip "\""
      return StringLiteral.new(string)
    end

    if input.peek == '\''
      input.next
      char = input.next
      return CharLiteral.new(char)
    end

    p! input.source[input.position..]
    raise "idk"
  end

  include Iterator(Token)

  def next
    token = next_token
    token.nil? ? stop : token
  end
end
