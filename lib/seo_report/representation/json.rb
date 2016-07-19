require "json"

module SeoReport::Representation
  class Json < Base
    def represent
      puts JSON(report.report)
    end
  end
end
