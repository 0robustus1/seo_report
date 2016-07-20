require "json"

module SeoReport::Representation
  class Json < Base
    def represent
      puts JSON(data)
    end
  end
end
