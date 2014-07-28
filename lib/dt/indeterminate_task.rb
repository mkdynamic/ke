module Dt
  class IndeterminateTask
    attr_reader :tick_count, :complete_time

    def initialize(opts = {})
      @tick_count = 0
      @duration_per_tick = 0
      @duration_per_tick_history = CappedSample.new(100)
      @mutex = Mutex.new
    end

    def start_time
      @start_time
    end

    def elapsed_duration
      Time.now - @start_time
    end

    def total_duration
      @complete_time - @start_time
    end

    def start
      @start_time = Time.now
    end

    def duration_per_tick
      @duration_per_tick_history.mean
    end

    def tick
      @mutex.synchronize do
        this_tick_time = Time.now
        duration_this_tick = this_tick_time - (@last_tick_time || start_time)
        @duration_per_tick_history << duration_this_tick
        @last_tick_time = this_tick_time
        @tick_count += 1
      end
    end

    def complete
      @complete_time = Time.now
    end
  end
end
