module SecondAmendmentWholesale
  class Image < Base

    include SecondAmendmentWholesale::API

    def initialize(options = {})
      requires!(options, :token)
      @options = options

      @headers = [ 
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h
    end

    def url(item_number)
      get_request("products/#{item_number}/media", @headers).body.first[:file]
    end

  end
end
