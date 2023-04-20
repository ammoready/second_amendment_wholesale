module SecondAmendmentWholesale
  class Shipping < Base

    include SecondAmendmentWholesale::API

    def initialize(options = {})
      requires!(options, :token)

      @options = options
      @headers = [ 
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h
    end

    def fetch(since_date = nil)
      since_date = (since_date || Time.now.prev_day).strftime('%Y/%m/%d')
      endpoint = "shipmentsInformation/me?fromShipmentCreateAt=#{since_date}"
      
      orders = get_request(endpoint, @headers)
    end

  end
end