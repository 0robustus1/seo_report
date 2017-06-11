module SeoReport
  class RequestChain
    attr_reader :initial_request
    attr_reader :request_chain, :terminal_request

    def initialize(initial_url, headers = {})
      @initial_request = Request.new(initial_url, headers)
      @request_chain = [@initial_request]
    end

    def perform
      loop do
        last_request.perform
        if has_redirection_response?(last_request)
          break if request_chain.length >= 10
          request_chain << build_new_request
        else
          @terminal_request = request_chain.last
          break
        end
      end
    end

    protected
    def last_request
      request_chain.last
    end

    def build_new_request
      location = last_request.response["Location"]
      url = build_url(last_request.url, location).to_s
      Request.new(url, headers)
    end

    def has_redirection_response?(request)
      code = request.response.code.to_i
      code >= 300 && code < 400
    end

    def build_url(base_url, url)
      new_url = URI(url)
      if new_url.relative?
        base = URI(base_url)
        new_url.scheme = base.scheme
        new_url.host = base.host
        new_url.port = base.port
      end
      new_url
    end
  end
end
