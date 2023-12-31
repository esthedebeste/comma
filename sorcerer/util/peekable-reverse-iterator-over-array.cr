class PeekableReverseIteratorOverArray(T)
  property array : Array(T)
  property index : Int32

  def initialize(@array : Array(T))
    @index = @array.size - 1
  end

  def initialize(@array : Array(T), @index : Int32)
  end

  def try
    previous = @index
    result = yield
    @index = previous if result.nil?
    result
  end

  def last
    @array[0]
  end

  def without_last
    PeekableReverseIteratorOverArray.new(@array[1..], @index - 1)
  end

  def size
    @array.size
  end

  def to_s
    "PeekableReverseIteratorOverArray(#{@array}, #{@index})"
  end

  include Iterator(T)

  def next : T | Iterator::Stop
    return stop if done
    @index -= 1
    @array[@index + 1]
  end

  def done : Bool
    @index < 0
  end

  def peek(extra : Int32 = 0) : T | Nil
    return nil if index - extra < 0
    @array[@index - extra]
  end
end
