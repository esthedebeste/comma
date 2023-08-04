class AgainStatement < Statement
  property start : String

  def initialize(@start)
  end

  def cppify : String
    "goto #{@start.cppify};"
  end
end
