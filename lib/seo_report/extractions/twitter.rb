module SeoReport
  module Extractions
    module Twitter
      def extract_twitter(doc)
        extract = -> (field) do
          result = doc.xpath(%{//head/meta[@name="twitter:#{field}"]}).
            map { |node| node.attr("content") }
          unarray(result)
        end
        {
          twitter: {
            card: extract.call("card"),
            domain: extract.call("domain"),
            title: extract.call("title"),
            description: extract.call("description"),
            site: extract.call("site"),
            creator: extract.call("creator"),
            image: extract.call("image"),
            image_alt: extract.call("image:alt"),
          }
        }
      end
    end

    SeoReport::Report.register_extraction(:html, Twitter, :extract_twitter)
  end
end
