# Ke [![Build Status](https://travis-ci.org/mkdynamic/ke.png)](https://travis-ci.org/mkdynamic/ke)

Measure progress of Ruby code with the ability to provide estimates for time until completion.

Supports tasks with a known (determinate) and unknown (indeterminate) number of iterations. For indeterminate tasks it's only possible to provide a rate. For determinate tasks it's possible to provide both a rate and an estimated remaining time.

## Usage

Install them gem with `gem install ke`. If you're using Bundler then add it to your Gemfile with `gem ke` and run `bundle install`. Usage examples below:

### Example 1: An indeterminate task with a multi line reporting output

```ruby
require 'ke'

task = Ke::IndeterminateTask.new
reporter = Ke::MultiLineReporter.new(task, "indeterminate task")
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
```

### Example 2: A determinate task with a single line reporting output

```ruby
require 'ke'

task = Ke::DeterminateTask.new(total_ticks: 50)
reporter = Ke::SingleLineReporter.new(task, "determinate task")
task.start
reporter.print_start
50.times do
  sleep 0.1
  task.tick
  reporter.print_tick if task.tick_count % 10 == 0
end
task.complete
reporter.print_complete
```

## Custom reporters

You can add your own reporters as needed. Scope the existing reporters to learn the interface.

## TODO

- Provide some syntactic sugar for the API, it's a bit rough at present
- Provide some pleasant looking default reporters (the current 2 work, but are ugly)
- Add some real tests
- Add more Ruby versions to Travis CI (anything 1.9+ compat should work)
- Measure the performanc impact
- Use other averages than SMA. WMA, EMA etc.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
