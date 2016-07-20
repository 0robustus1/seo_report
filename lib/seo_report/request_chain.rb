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
          request_chain << Request.new(last_request.response["Location"])
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

    def has_redirection_response?(request)
      code = request.response.code.to_i
      code >= 300 && code < 400
    end
  end
end
