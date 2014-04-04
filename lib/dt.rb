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
    attr_reader :tick_count, :complete_time

    def initialize(opts = {})
      @tick_count = 0
      @duration_per_tick = 0
      @duration_per_tick_history = CappedSample.new(100)
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

  class DeterminateTask < IndeterminateTask
    def initialize(opts = {})
      super
      @total_ticks = opts[:total_ticks]
    end

    def estimated_duration_until_complete
      ticks_remaining = [@total_ticks - @tick_count, 0].max
      ticks_remaining * duration_per_tick
    end
  end

  class MultiLineReporter
    def initialize(task, label, io = STDOUT)
      @task = task
      @label = label
      @io = io
    end

    def print_start
      @io.puts "Starting #{@label}"
    end

    def print_tick
      ticks_per_second = (1 / @task.duration_per_tick).round(2)
      elapsed_time = (@task.elapsed_duration / 60.0).round(2)

      if @task.respond_to?(:estimated_duration_until_complete)
        estimated_duration_until_complete = (@task.estimated_duration_until_complete / 60.0).round(2)
        @io.puts "Running #{@label}, #{elapsed_time} minutes elapsed, #{estimated_duration_until_complete} minutes remaining"
      else
        @io.puts "Running #{@label}, #{elapsed_time} minutes elapsed, #{ticks_per_second} ticks/second"
      end
    end

    def print_complete
      @io.puts "Completed #{@label}, #{@task.total_duration} total duration"
    end
  end

  class SingleLineReporter
    def initialize(task, label, io = STDOUT)
      @task = task
      @label = label
      @io = io
    end

    def print_start
      @io.print "Starting #{@label}"
    end

    def print_tick
      ticks_per_second = (1 / @task.duration_per_tick).round(2)
      elapsed_time = (@task.elapsed_duration / 60.0).round(2)

      if @task.respond_to?(:estimated_duration_until_complete)
        estimated_duration_until_complete = (@task.estimated_duration_until_complete / 60.0).round(2)
        @io.print "{#{elapsed_time}/#{estimated_duration_until_complete} mins}"
      else
        @io.print "{#{elapsed_time} mins, #{ticks_per_second} ticks/sec}"
      end
    end

    def print_complete
      @io.puts "complete."
    end
  end
end

task = Dt::IndeterminateTask.new
reporter = Dt::MultiLineReporter.new(task, "indeterminate task")
task.start
reporter.print_start
loop do
  break if rand(200) == 50
  sleep 0.1
  task.tick
  reporter.print_tick if task.tick_count % 10 == 0
end
task.complete
reporter.print_complete

task = Dt::DeterminateTask.new(total_ticks: 50)
reporter = Dt::SingleLineReporter.new(task, "determinate task")
task.start
reporter.print_start
50.times do
  sleep 0.1
  task.tick
  reporter.print_tick if task.tick_count % 10 == 0
end
task.complete
reporter.print_complete
