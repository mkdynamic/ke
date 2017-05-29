module Ke
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
      @io.puts "#{prefix}#{infix}#{suffix}"
    end

    def print_complete
      @io.puts "Completed #{@label}, #{@task.total_duration} total duration"
    end

    private

    def prefix
      elapsed_time = (@task.elapsed_duration / 60.0).round(2)
      "Running #{@label}, #{elapsed_time} minutes elapsed"
    end

    def infix
      if @task.respond_to?(:estimated_duration_until_complete)
        estimated_duration_until_complete = (@task.estimated_duration_until_complete / 60.0).round(2)
        ", #{estimated_duration_until_complete} minutes remaining"
      else
        ticks_per_second = (1.0 / @task.duration_per_tick).round(2)
        ", #{ticks_per_second} ticks/second"
      end
    end

    def suffix
      if @task.respond_to?(:total_ticks)
        pct = (@task.tick_count.to_f * 100 / @task.total_ticks).round(2)
        ", #{@task.tick_count}/#{@task.total_ticks} ticks ~ #{pct}% complete"
      end
    end
  end
end
