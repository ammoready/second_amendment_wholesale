module SecondAmendmentWholesale
  class Attribute < Base

    include SecondAmendmentWholesale::API

    def initialize(options = {})
      requires!(options, :token)

      @options = options
    end

    def self.all(options = {})
      requires!(options, :token)

      new(options).all
    end

    def all
      headers = [ 
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h

      get_request('feed/attributes', headers).body
    end
  end
end
