module SeoReport::Representation
  class Base
    attr_reader :report

    def self.represent_with_report_for(url)
      report = SeoReport::Report.new(url)
      report.produce
      new(report).represent
    end

    def initialize(report)
      @report = report
    end

    def represent
      raise NotImplementedError.new("#represent needs to be implemented by a subclass.")
    end
  end
end
