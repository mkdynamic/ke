require 'ke/version'
require 'ke/capped_sample'
require 'ke/indeterminate_task'
require 'ke/determinate_task'
require 'ke/reporters/single_line_reporter'
require 'ke/reporters/multi_line_reporter'
require 'ke/job'

module Ke
  def self.job(*args, &blk)
    total_ticks = args[0] if Integer === args[0]
    label = args[1] if String === args[1]
    opts = args.detect { |arg| Hash === arg } || {}

    task_class = total_ticks ? DeterminateTask : IndeterminateTask
    task_opts = opts[:task_opts] || {}
    task_opts = task_opts.merge(total_ticks: total_ticks) if total_ticks

    reporter_class = opts[:reporter] || MultiLineReporter
    reporter_label = label || "task"
    reporter_io = opts[:io] || STDOUT

    job_class = Job
    job_opts = opts || {}

    task = task_class.new(task_opts)
    reporter = reporter_class.new(task, reporter_label, reporter_io)
    job = job_class.new(task, reporter, job_opts)

    job.run(&blk)
  end
end
