require 'test_helper'

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
