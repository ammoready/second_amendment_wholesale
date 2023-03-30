module SecondAmendmentWholesale
  class Order < Base

    include SecondAmendmentWholesale::API

    ENDPOINTS = {
      cart: "carts/mine".freeze,
      items: 'carts/mine/items'.freeze,
      licence: "carts/licence".freeze,
      payment_information: 'carts/mine/payment-information'.freeze,
      po_number: 'carts/mine/set-po-number'.freeze,
      regions: 'directory/countries/US'.freeze,
      shipping_information: 'carts/mine/shipping-information'.freeze,
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

    def create_cart
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

    def add_po_number(po_number, quote_id)
      endpoint = ENDPOINTS[:po_number]

      body = {
        "cartId": "#{quote_id}",
        "poNumber": {
            "poNumber": "#{po_number}"
        }
      }

     put_request(endpoint, body, @headers)
    end

    def get_regions
      endpoint = ENDPOINTS[:regions]

      get_request(endpoint, @headers).body[:available_regions]
    end

    def get_shipping_methods(address)
      endpoint = ENDPOINTS[:shipping_methods]

      body = {
        "address": address
      }

      post_request(endpoint, body, @headers).body
    end

    def add_shipping_information(shipping_data)
      endpoint = ENDPOINTS[:shipping_information]

      post_request(endpoint, shipping_data, @headers)[:payment_methods]
    end

    def submit_payment(payment_method)
      endpoint = ENDPOINTS[:payment_information]

      agreement_ids = get_agreement_ids

      body = {
        "payment_method": {
          "method": payment_method,
          "extension_attributes": {
            "agreement_ids": agreement_ids
          }
        }
      }
      
      # This response is the order number from 2AW
      post_request(endpoint, body, @headers).body
    end

    private

    def get_agreement_ids
      endpoint = ENDPOINTS[:licence]

      get_request(endpoint, @headers).body.pluck(:agreement_id)
    end

  end
end