module Ke
  class CappedSample
    def initialize(limit)
      @array = []
      @limit = limit
    end

    def push(element)
      @array << element
      @array.shift if @array.size > @limit
      self
    end
    alias :<< :push

    def size
      @array.size
    end

    def to_a
      @array.dup
    end
    alias :to_ary :to_a

    def mean
      if @array.size > 0
        @array.inject(:+) / @array.size.to_f
      else
        0
      end
    end

    def to_s
      "#<CappedSample: #{@array.inspect}>"
    end
  end
end
