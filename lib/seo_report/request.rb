require "net/http"
require "net/https"

module SeoReport
  class Request
    class Error < ::StandardError; end
    class NoRequestPerformedYetError < Error; end

    attr_reader :url

    def initialize(url, headers = {})
      @url = URI(url)
      @headers = headers
    end

    def perform
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = url.is_a?(URI::HTTPS)
      @response = http.request(http_request)
    end

    def request
      if @response
        http_request
      else
        raise NoRequestPerformedYetError.new(url)
      end
    end

    def response
      @response or raise NoRequestPerformedYetError.new(url)
    end

    def headers
      {
        "User-Agent" => "seo-report/#{SeoReport::VERSION} Net::HTTP"
      }.merge(@headers || {})
    end

    protected
    def http_request
      @http_request ||= Net::HTTP::Get.new(url.request_uri, headers)
    end
  end
end
