module Ke
  class SingleLineReporter
    def initialize(task, label, io = STDOUT)
      @task = task
      @label = label
      @io = io
    end

    def print_start
      @io.print "Starting #{@label} ..."
    end

    def print_tick
      ticks_per_second = (1 / @task.duration_per_tick).round(2)
      elapsed_time = (@task.elapsed_duration / 60.0).round(2)

      if @task.respond_to?(:estimated_duration_until_complete)
        estimated_duration_until_complete = (@task.estimated_duration_until_complete / 60.0).round(2)

        if @task.respond_to?(:total_ticks)
          pct = (@task.tick_count.to_f * 100 / @task.total_ticks).round(2)
          @io.print " #{elapsed_time}/#{estimated_duration_until_complete} mins, #{@task.tick_count}/#{@task.total_ticks} ticks ~ #{pct}% ..."
        else
          @io.print " #{elapsed_time}/#{estimated_duration_until_complete} mins ..."
        end
      else
        @io.print " #{elapsed_time} mins, #{ticks_per_second} ticks/sec ..."
      end
    end

    def print_complete
      @io.puts " complete (#{@task.total_duration} total duration)."
    end
  end
end
