module Dt
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
end
