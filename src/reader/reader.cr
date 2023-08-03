struct Char
  def identifier?
    self.ascii_alphanumeric? || self == '_'
  end
end

class Reader
  property source : String
  property position : Int64 = 0

  def initialize(@source)
  end

  def self.from_file(path : String)
    new(File.read(path))
  end

  def eof?
    @position >= @source.size
  end

  # Returns the current character and advances the position
  def next
    return '\0' if eof?
    @position += 1
    @source[@position - 1]
  end

  # Advances the position by n characters
  def skip(n : Int64 = 1)
    @position += n
  end

  # Skips the given string if it matches the next characters, otherwise returns false
  def skip(string : String)
    return false unless peek_is?(string)
    @position += string.size
    true
  end

  def skip_whitespace
    while true
      char = peek
      break if char.nil? || !char.whitespace?
      skip
    end
  end

  # Returns the current character without advancing the position
  def peek
    return '\0' if eof?
    source[position]
  end

  # Returns the next n characters without advancing the position
  def peek(n : Int64)
    return nil if position + n > source.size
    source[position, n]
  end

  # Returns true if the next characters match the given string. Does not advance the position.
  def peek_is?(string : String)
    return false if position + string.size > source.size
    if string[-1].identifier?
      return false if position + string.size >= source.size || source[position + string.size].identifier? # make sure the next character is not a word character
    end
    peek(string.size) == string
  end
end
