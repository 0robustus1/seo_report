module SeoReport
  module Extractions
    module Head
      def extract_head(doc)
        title = doc.xpath('//head/title').text
        description = doc.xpath('//head/meta[@name="description"]').
                      map { |node| node.attr("content") }
        title = nil if title.empty?
        {
          title: title,
          description: unarray(description),
        }
      end
    end

    SeoReport::Report.register_extraction(:html, Head, :extract_head)
  end
end
