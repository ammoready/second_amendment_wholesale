require 'net/http'

module SecondAmendmentWholesale
  module API
    
    ROOT_API_URL = 'https://www.2ndamendmentwholesale.com/rest/V1'.freeze

    def get_request(endpoint, headers = {})
      request = Net::HTTP::Get.new(request_url(endpoint))

      submit_request(request, {}, headers)
    end

    def post_request(endpoint, data = {}, headers = {})
      request = Net::HTTP::Post.new(request_url(endpoint))

      submit_request(request, data, headers)
    end

    def put_request(endpoint, data = {}, headers = {})
      request = Net::HTTP::Put.new(request_url(endpoint))

      submit_request(request, data, headers)
    end

    def delete_request(endpoint, headers = {})
      request = Net::HTTP::Delete.new(request_url(endpoint))

      submit_request(request, {}, headers)
    end
    
    private

    def submit_request(request, data, headers)
      set_request_headers(request, headers)

      request.body = data.is_a?(Hash) ? data.to_json : data

      process_request(request)
    end

    def process_request(request)
      uri = URI(request.path)

      response = Net::HTTP.start(uri.host, uri.port, SecondAmendmentWholesale.config.proxy_address, SecondAmendmentWholesale.config.proxy_port, use_ssl: true) do |http|
        http.request(request)
      end

      SecondAmendmentWholesale::Response.new(response)
    end

     def set_request_headers(request, headers)
      request['User-Agent'] = SecondAmendmentWholesale.config.user_agent

      headers.each { |header, value| request[header] = value }
    end

    def auth_header(token)
      { 'Authorization' => "Bearer #{token}" }
    end

    def content_type_header(type)
      { 'Content-Type' => type }
    end

    def request_url(endpoint)
      [ROOT_API_URL, endpoint].join('/')
    end
  end
end
