require 'second_amendment_wholesale/api'

module SecondAmendmentWholesale
  class Client < Base

    include SecondAmendmentWholesale::API

    attr_accessor :bearer_token

    def initialize(options = {})
      requires!(options, :token)
      @options = options

      authenticate!
    end

    private

    def authenticate!
      headers = [
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h

      response = get_request(
        'token/validate',
        headers
      )

      if response.body.present?
        self.bearer_token = @options[:token]
      else
        raise SecondAmendmentWholesale::Error::NotAuthorized.new(response.body)
      end
    end

  end
end