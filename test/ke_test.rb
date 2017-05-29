require 'test_helper'

[Ke::MultiLineReporter, Ke::SingleLineReporter].each do |reporter_klass|
  task = Ke::IndeterminateTask.new
  reporter = reporter_klass.new(task, "indeterminate task")
  task.start
  reporter.print_start
  loop do
    break if rand(200) == 50
    sleep 0.05 + (rand / 100.0)
    task.tick
    reporter.print_tick if task.tick_count % 10 == 0
  end
  task.complete
  reporter.print_complete

  task = Ke::DeterminateTask.new(total_ticks: 50)
  reporter = reporter_klass.new(task, "determinate task")
  task.start
  reporter.print_start
  50.times do
    sleep 0.05 + (rand / 100.0)
    task.tick
    reporter.print_tick if task.tick_count % 10 == 0
  end
  task.complete
  reporter.print_complete
end
