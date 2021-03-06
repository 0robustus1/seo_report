require "forwardable"

module SeoReport::Representation
  class Base
    extend Forwardable

    attr_reader :report
    def_delegators :report, :data

    def self.represent_with_report_for(url)
      report = SeoReport::Report.new(url)
      report.produce
      new(report).represent
    rescue StandardError => _error
      debug = ENV["SEO_REPORT_DEBUG"]
      if debug.to_i > 0
        raise
      else
        abort("-- Sorry, something went wrong when creating the report.")
      end
    end

    def initialize(report)
      @report = report
    end

    def represent
      raise NotImplementedError.new("#represent needs to be implemented by a subclass.")
    end

    def any_data_in_hash?(hash)
      (hash || {}).select { |_, val| !val.nil? }.any?
    end
  end
end
