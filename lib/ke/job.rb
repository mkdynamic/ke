module Ke
  class Job
    attr_reader :task, :reporter, :opts

    def initialize(task, reporter, opts = {})
      @task = task
      @reporter = reporter
      @opts = opts

      @opts[:report_every] ||= if @task.respond_to?(:total_ticks)
        [1, [@task.total_ticks / 10, 100].min].max
      else
        1
      end
    end

    def tick
      task.tick
      reporter.print_tick if task.tick_count % opts[:report_every] == 0
      yield
    end

    def run
      task.start
      reporter.print_start
      return_val = yield(self)
      task.complete
      reporter.print_complete
      return_val
    end
  end
end
