module SecondAmendmentWholesale
  class Order < Base

    include SecondAmendmentWholesale::API

    ENDPOINTS = {
      cart: "carts/mine".freeze,
      items: 'carts/mine/items'.freeze,
      po_number: 'carts/mine/set-po-number'.freeze,
    }

    def initialize(options = {})
      requires!(options, :token)

      @options = options
      @headers = [ 
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h
    end

    def get_cart
      endpoint = ENDPOINTS[:cart]

      get_request(endpoint, @headers).body
    end

    def post_cart
      endpoint = ENDPOINTS[:cart]

      post_request(endpoint, @headers).body
    end

    def delete_cart_items(cart_items)
      responses = []

      cart_items.each do |item|
        responses << delete_request([ENDPOINTS[:items], item[:item_id]].join("/"), @headers).body
      end

      responses.all?
    end

    def add_cart_item(item)
      endpoint = ENDPOINTS[:items]

      post_request(endpoint, item, @headers)
    end

    def add_po(quote_id, po_number)
      endpoint = ENDPOINTS[:po_number]

      body = {
        "cartId": "#{quote_id}",
        "poNumber": {
            "poNumber": "#{po_number}"
        }
      }

      put_request(endpoint, body, @headers)
    end

    # at some point our fulfillment number should be added as the PO number in 2AW PUT /rest/V1/carts/mine/set-po-number
    # get region_id for state GET /V1/directory/countries/US
    # get shipping options for shipping address, include region_id, /V1/carts/mine/estimate-shipping-methods
    # set shipping/billing with shipping method, POST V1/carts/mine/shipping-information, this also returns available payment methods to be used later
    # get agreement ids, V1/carts/licence
    # post payment method from before, with agreement ids, /V1/carts/mine/payment-information
    # save order number from response on fulfillment
  end
end