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
          }
        }
      end
    end

    SeoReport::Report.register_extraction(:html, Twitter, :extract_twitter)
  end
end
