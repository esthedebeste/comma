class PeekableReverseIteratorOverArray(T)
  property array : Array(T)
  property index : Int32

  def initialize(@array : Array(T))
    @index = @array.size - 1
  end

  def initialize(@array : Array(T), @index : Int32)
  end

  def try(&block : self -> _)
    previous = @index
    result = block.call(self)
    if result.nil?
      @index = previous
    end
    result
  end

  def to_s
    "PeekableReverseIteratorOverArray(#{@array}, #{@index})"
  end

  include Iterator(T)

  def next : T | Iterator::Stop
    if @index >= 0
      @index -= 1
      @array[@index + 1]
    else
      stop
    end
  end

  def done : Bool
    @index < 0
  end

  def peek(extra : Int32 = 0) : T | Nil
    return nil if index - extra < 0
    @array[@index - extra]
  end
end
