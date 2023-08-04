class Block < Statement
  property statements : Array(Statement)

  def initialize(@statements : Array(Statement))
  end

  def cppify : String
    @statements.join("\n")
  end
end
