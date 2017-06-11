require "nokogiri"

module SeoReport
  class Report
    attr_reader :start_url, :headers
    attr_reader :data

    def self.register_extraction(type, module_name, *method_names)
      include module_name
      extractions_for_type = extractions[type] ||= []
      method_names.each { |m| extractions_for_type << m }
    end

    def self.extractions
      @extractions ||= {}
    end

    def initialize(start_url, headers = {})
      @start_url = start_url
      @headers = headers
    end

    def produce
      @data = generate_report
    end

    protected
    def generate_report
      {
        requests: request_chain.request_chain.map do |request|
          {
            request_url: request.url.to_s,
            response_code: request.response.code.to_i
          }.merge(generate_html_report(request))
        end
      }
    end

    def request_chain
      @request_chain ||= build_request_chain
    end

    def build_request_chain
      RequestChain.new(start_url, headers).tap(&:perform)
    end

    def generate_html_report(request)
      if request.response.is_a?(Net::HTTPOK)
        doc = Nokogiri::HTML(request.response.body)
        content_through_extractions({}, doc, type: :html)
      elsif request.response.is_a?(Net::HTTPRedirection)
        {
          location: request.response["Location"],
        }
      else
        {}
      end
    end

    def content_through_extractions(base, document, type: :html)
      self.class.extractions.fetch(type, []).reduce(base) do |current, method_name|
        current.merge(send(method_name, document))
      end
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
