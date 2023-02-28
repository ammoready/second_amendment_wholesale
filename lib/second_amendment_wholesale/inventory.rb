module SecondAmendmentWholesale
  class Inventory < Base

    include SecondAmendmentWholesale::API

    def initialize(options = {})
      requires!(options, :token)

      @options = options
      @headers = [ 
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h
    end

    def self.all(options = {})
      requires!(options, :token)

      new(options).all
    end
    class << self; alias_method :quantity, :all; end

    def all
      items = []

      response = get_request("feed/stockV2", @headers)

      response.body.each do |item|
        items << map_hash(item)
      end

      items
    end

    private

    def map_hash(item)
      {
        item_identifier: item[:sku],
        quantity: item[:qty],
        price: item[:dealer_price],
      }
    end

  end
end
