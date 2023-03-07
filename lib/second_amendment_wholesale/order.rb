module SecondAmendmentWholesale
  class Order < Base

    include SecondAmendmentWholesale::API

    ENDPOINTS = {
      cart: "carts/mine".freeze,
      items: 'carts/mine/items'.freeze,
      po_number: 'carts/mine/set-po-number'.freeze,
      regions: 'directory/countries/US'.freeze,
      shipping_methods: 'carts/mine/estimate-shipping-methods'.freeze,
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

    def add_po_number(quote_id, po_number)
      endpoint = ENDPOINTS[:po_number]

      body = {
        "cartId": "#{quote_id}",
        "poNumber": {
            "poNumber": "#{po_number}"
        }
      }

     put_request(endpoint, body, @headers).body
    end

    def get_shipping_methods(address)
      endpoint = ENDPOINTS[:shipping_methods]

      regions = get_regions

      address[:region_id] = regions.find{ |region| region[:code] == address[:region_code]}[:id]

      body = {
        "address": address
      }

      post_request(endpoint, body, @headers).body
    end

    private

    def get_regions
      endpoint = ENDPOINTS[:regions]

      get_request(endpoint, @headers).body[:available_regions]
    end

    # set shipping/billing with shipping method, POST V1/carts/mine/shipping-information, this also returns available payment methods to be used later
    # get agreement ids, V1/carts/licence
    # post payment method from before, with agreement ids, /V1/carts/mine/payment-information
    # save order number from response on fulfillment
  end
end