module SeoReport
  module Extractions
    module Twitter
      def extract_twitter(doc)
        card = doc.xpath('//head/meta[@name="twitter:card"]').
               map { |node| node.attr("content") }
        domain = doc.xpath('//head/meta[@name="twitter:domain"]').
                 map { |node| node.attr("content") }
        title = doc.xpath('//head/meta[@name="twitter:title"]').
                map { |node| node.attr("content") }
        description = doc.xpath('//head/meta[@name="twitter:description"]').
                      map { |node| node.attr("content") }
        {
          twitter: {
            card: unarray(card),
            domain: unarray(domain),
            title: unarray(title),
            description: unarray(description),
          }
        }
      end
    end

    SeoReport::Report.register_extraction(:html, Twitter, :extract_twitter)
  end
end
