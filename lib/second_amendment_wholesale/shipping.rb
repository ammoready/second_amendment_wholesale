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
      
      orders = get_request(endpoint, @headers).body

      shipments = []

      orders.each do |order|
        order[:shipments].each do |shipment|
          if shipment[:tracking_information].present?
            tracking_data = { :order_id=>shipment[:order_id], :tracking_numbers=>[] }

            shipment[:tracking_information].each_value do |tracking|
              tracking_data[:tracking_numbers] << tracking[:track_number]
            end

            shipments << tracking_data
          end
        end
      end
    end

  end
end