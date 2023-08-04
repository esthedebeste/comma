class NotAgainStatement < Statement
  property endname : String

  def initialize(@endname)
  end

  def cppify : String
    "goto #{@endname.cppify};"
  end
end
