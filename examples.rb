require 'ke'

# Simplest usage, no arguments.
Ke.job do |job|
  50.times do
    job.tick do
      sleep 0.1
    end
  end
end

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
