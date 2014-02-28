#require 'dt/version'

module Dt
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

  class IndeterminateTask
    attr_reader :tick_count

    def initialize
      @tick_count = 0
      @duration_per_tick = 0
      @duration_per_tick_history = CappedSample.new(100)
    end

    def start_time
      @start_time ||= Time.now
    end

    def elapsed_duration
      Time.now - @start_time
    end

    def total_duration
      @end_time - @start_time
    end

    def start
      @start_time = Time.now
    end

    def duration_per_tick
      @duration_per_tick_history.mean
    end

    def tick
      this_tick_time = Time.now
      duration_this_tick = this_tick_time - (@last_tick_time || start_time)
      @duration_per_tick_history << duration_this_tick

      @last_tick_time = this_tick_time
      @tick_count += 1
    end

    def complete
      @complete_time = Time.now
    end
  end
end

task = Dt::IndeterminateTask.new
i = 0
task.start
loop do
  break if rand(1_000) == 500
  sleep 0.01
  i += 1
  task.tick

  if i % 10 == 0
    puts "Start time:    #{task.start_time}"
    puts "Elapsed time:  #{task.elapsed_duration}"
    puts "Time per tick: #{task.duration_per_tick}"
    puts "Tick count:    #{task.tick_count}"
    puts
  end
end
task.complete

puts
puts "Start time:    #{task.start_time}"
puts "Elapsed time:  #{task.elapsed_duration}"
puts "Time per tick: #{task.duration_per_tick}"
puts "Tick count:    #{task.tick_count}"
