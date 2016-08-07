module SeoReport
  module Extractions
    module Opengraph
      def extract_og(doc)
        type = doc.xpath('//head/meta[@property="og:type"]').
               map { |node| node.attr("content") }
        title = doc.xpath('//head/meta[@property="og:title"]').
                map { |node| node.attr("content") }
        description = doc.xpath('//head/meta[@property="og:description"]').
                      map { |node| node.attr("content") }
        site_name = doc.xpath('//head/meta[@property="og:site_name"]').
                    map { |node| node.attr("content") }
        image = doc.xpath('//head/meta[@property="og:image"]').
                map { |node| node.attr("content") }
        url = doc.xpath('//head/meta[@property="og:url"]').
              map { |node| node.attr("content") }
        {
          og: {
            type: unarray(type),
            title: unarray(title),
            description: unarray(description),
            site_name: unarray(site_name),
            image: unarray(image),
            url: unarray(url),
          }
        }
      end
    end

    SeoReport::Report.register_extraction(:html, Opengraph, :extract_og)
  end
end
