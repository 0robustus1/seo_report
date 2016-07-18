require "nokogiri"

module SeoReport
  class Report
    attr_reader :start_url, :report

    def initialize(start_url)
      @start_url = start_url
    end

    def produce
      @report = generate_report
    end

    protected
    def generate_report
      initial_request = Request.new(start_url)
      initial_request.perform
      {
        request_url: start_url,
        response_code: initial_request.response.code.to_i
      }.merge(generate_html_report(initial_request))
    end

    def generate_html_report(request)
      if request.response.is_a?(Net::HTTPOK)
        doc = Nokogiri::HTML(request.response.body)
        {}.merge(extract_head(doc)).
          merge(extract_robots(doc)).
          merge(extract_canonical(doc)).
          merge(extract_twitter(doc)).
          merge(extract_og(doc))
      elsif request.response.is_a?(Net::HTTPRedirection)
        {
          location: request.response["Location"],
        }
      else
        {}
      end
    end

    def extract_head(doc)
      title = doc.xpath('//head/title').text
      description = doc.xpath('//head/meta[@name="description"]').
                    map { |node| node.attr("content") }
      {
        title: title,
        description: unarray(description),
      }
    end

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

    def unarray(array)
      if array.respond_to?(:length) && array.respond_to?(:first)
        if array.length <= 1
          array.first
        else
          array
        end
      else
        array
      end
    end
  end
end
