require "./peekable-reverse-iterator-over-array"
require "./debu"

class String
  def cppify
    "comma_#{self}_"
  end
end
