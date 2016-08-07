module SeoReport
  module Extractions
    module Seo
      def extract_robots(doc)
        robots_tags = doc.xpath('//head/meta[@name="robots"]').
                      map { |node| node.attr("content") }
        {robots: robots_tags}
      end

      def extract_canonical(doc)
        canonical = doc.xpath('//head/link[@rel="canonical"]').
                    map { |node| node.attr("href") }
        {canonical: unarray(canonical)}
      end
    end

    SeoReport::Report.register_extraction(:html, Seo, :extract_robots, :extract_canonical)
  end
end
