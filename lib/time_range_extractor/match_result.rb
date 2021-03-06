# frozen_string_literal: true

module TimeRangeExtractor
  class MatchResult
    def initialize(match_data)
      @match_data = match_data
    end

    def valid?
      @match_data && (start_time.present? && end_time.present?)
    end

    def start_time
      match_data[:start_time]
    end

    def start_period
      @start_period ||= match_data[:start_period].presence || begin
        force_start_period_to_am? ? 'am' : end_period
      end
    end

    def end_time
      match_data[:end_time]
    end

    def end_period
      match_data[:end_period]
    end

    def time_zone
      match_data[:time_zone]
    end

    def start_time_string
      [start_time, start_period, time_zone].compact.join(' ')
    end

    def end_time_string
      [end_time, end_period, time_zone].compact.join(' ')
    end

    private

    def range?
      start_time.present? && end_time.present?
    end

    def force_start_period_to_am?
      start_t = start_time.to_i
      end_t = end_time.to_i

      end_period.casecmp('pm') == 0 &&
        (start_t > end_t || (end_t == 12 && start_t < end_t))
    end

    attr_reader :match_data
  end
end
