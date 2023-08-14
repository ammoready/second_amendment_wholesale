module SecondAmendmentWholesale
  class Response

    def initialize(response)
      @response = response

      case @response
      when Net::HTTPUnauthorized
        raise SecondAmendmentWholesale::Error::NotAuthorized.new(@response.body)
      when Net::HTTPNotFound
        raise SecondAmendmentWholesale::Error::NotFound.new(@response.body)
      when Net::HTTPBadRequest
        raise SecondAmendmentWholesale::Error::BadRequest.new(@response.body)
      when Net::HTTPOK, Net::HTTPSuccess
        _data = (JSON.parse(@response.body) if @response.body.present?)

        @data = case
        when _data.is_a?(Hash)
          _data.deep_symbolize_keys
        when _data.is_a?(Array)
          _data.map(&:deep_symbolize_keys)
        else
          _data
        end
      else
        raise SecondAmendmentWholesale::Error::RequestError.new(@response.body)
      end

    end

    def [](key)
      @data&.[](key)
    end

    def body
      @data
    end
    
  end
end
