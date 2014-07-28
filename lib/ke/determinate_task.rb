module Ke
  class DeterminateTask < IndeterminateTask
    def initialize(opts = {})
      super
      @total_ticks = opts[:total_ticks]
    end

    def estimated_duration_until_complete
      ticks_remaining = [@total_ticks - @tick_count, 0].max
      ticks_remaining * duration_per_tick
    end
  end
end
