class Assignment < Statement
  property name : String
  property value : Expression

  def initialize(@name, @value)
  end

  def cppify : String
    "#{@name.cppify} = #{@value};"
  end
end
