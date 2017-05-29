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
      array_mean @array
    end

    def mean_iqr
      array_sorted = @array.sort
      array_size = @array.size
      iqr = array_sorted[(array_size * 0.25).floor..(array_size * 0.75).ceil]
      array_mean iqr
    end

    def to_s
      "#<CappedSample: #{@array.inspect}>"
    end

    private

    def array_mean(array)
      if @array.size > 0
        @array.inject(:+) / @array.size.to_f
      else
        0
      end
    end
  end
end
