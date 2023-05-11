module SecondAmendmentWholesale
  class User < Base

    include SecondAmendmentWholesale::API

    def initialize(options = {})
      requires!(options, :token)

      @options = options
    end

    def authenticated?
      headers = [
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h

      response = get_request(
        'token/validate',
        headers
      )

      response.body.present?
    end

  end
end
