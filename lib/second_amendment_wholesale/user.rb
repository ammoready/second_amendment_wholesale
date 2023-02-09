module SecondAmendmentWholesale
  class User < Base

    def initialize(options = {})
      requires!(options, :token)

      @client = SecondAmendmentWholesale::Client.new(token: options[:token])
    end

    def authenticated?
      @client.bearer_token.present?
    end

  end
end