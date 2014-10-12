# Ke [![Build Status](https://travis-ci.org/mkdynamic/ke.png)](https://travis-ci.org/mkdynamic/ke)

Measure progress of Ruby code with the ability to provide estimates for time until completion.

Supports tasks with a known (determinate) and unknown (indeterminate) number of iterations. For indeterminate tasks it's only possible to provide a rate. For determinate tasks it's possible to provide both a rate and an estimated remaining time.

## Installation

Install them gem with `gem install ke`.

If you're using Bundler then add it to your Gemfile with `gem ke` and run `bundle install`.

## Usage

Assume this is your code before, performing some work each iteration:

```ruby
5.times do
  sleep 0.1 # do work
end
```

To report on the progress as the code runs, you need to wrap with in `Ke.job {}` block, and wrap the "work" code in the iteration part in a `job.tick {}` block:

```ruby
Ke.job do |job|
  5.times do
    job.tick do
      sleep 1
    end
  end
end
```

Now when we run this, we'll see a progress report printed to `STDOUT` as the iteration proceeds:

```
Starting task
Running task, 0.0 minutes elapsed, 27027.03 ticks/second
Running task, 0.02 minutes elapsed, 2.0 ticks/second
Running task, 0.03 minutes elapsed, 1.5 ticks/second
Running task, 0.05 minutes elapsed, 1.33 ticks/second
Running task, 0.07 minutes elapsed, 1.25 ticks/second
Completed task, 5.005121 total duration
```

### More examples

```ruby
# Set a specific reporter.
Ke.job(reporter: Ke::MultiLineReporter) do |job|
  50.times do
    job.tick do
      sleep 0.1
    end
  end
end

# Set the total number of ticks, so we use DeterminateTask and get a time remaining estimates.
Ke.job(50) do |job|
  50.times do
    job.tick do
      sleep 0.1
    end
  end
end

# Report progress every 10 ticks.
Ke.job(report_every: 10) do |job|
  50.times do
    job.tick do
      sleep 0.1
    end
  end
end

# Report to a file.
File.open("log.txt", "w") do |f|
  f.sync = true

  Ke.job(io: f) do |job|
    50.times do
      job.tick do
        sleep 0.1
      end
    end
  end
end
```

## Custom reporters

You can add your own reporters as needed. Scope the existing reporters to learn the interface.

## TODO

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
