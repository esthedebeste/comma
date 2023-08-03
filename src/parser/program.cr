require "./statement"

class Program
  property statements : Array(Statement)

  def initialize(@statements : Array(Statement))
  end
end
