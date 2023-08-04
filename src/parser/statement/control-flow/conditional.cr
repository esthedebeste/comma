class ConditionalStatement < Statement
  property label : String
  property elifs : Array({condition: Expression, block: Block})
  property else_body : Block | Nil

  def initialize(@label, @elifs, @else_body)
  end

  def cppify : String
    result = "#{label.cppify}:"
    elifs.each_with_index do |elif, i|
      result += "#{i > 0 ? "else " : ""}if (#{elif[:condition]}) { #{elif[:block]} }"
    end
    els = @else_body
    if !els.nil?
      result += "else { #{els} }"
    end
    result += "#{label.reverse.cppify}:;"
    result
  end
end
