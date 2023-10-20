module SecondAmendmentWholesale
  class Catalog < Base

    include SecondAmendmentWholesale::API

    def initialize(options = {})
      requires!(options, :token)

      @options = options
      @headers = [ 
        *auth_header(@options[:token]),
        *content_type_header('application/json'),
      ].to_h

      @categories = SecondAmendmentWholesale::Category.all(@options)
      @attributes = SecondAmendmentWholesale::Attribute.all(@options)
    end

    def self.all(options = {})
      requires!(options, :token)

      new(options).all
    end

    def all
      products = []

      response = get_request("feed/productV2", @headers)

      response.body.each do |item|
        products << map_product(item)
      end

      products
    end

    private

    def map_product(item)
      {
        name: item[:product_description],
        model: item[:model],
        upc: item[:upc],
        long_description: item[:description],
        short_description: item[:product_description],
        category: get_category(item[:category_ids]),
        price: item[:dealer_price],
        map_price: item[:retail_map],
        msrp: item[:retail_price],
        quantity: item[:inventory_qty],
        weight: item[:weight],
        item_identifier: item[:stock_number],
        brand: item[:manufacturer_name],
        mfg_number: item[:mpn],
        features: get_features(item.slice(:stock_number, :ap_spend, :moqpts)),
      }
    end

    def get_category(category_ids)
      categories = []

      category_ids.each do |category_id|
        categories << @categories.find { |category| category[:id] == category_id.to_i }
      end

      categories.compact.pluck(:name).join(" ")
    end

    def get_features(item)
      attributes = @attributes.find { |attribute| attribute[:sku] == item[:stock_number] }

      return {} unless attributes.present?
      
      {
        purchase_limit: item[:moqpts],
        allocation_points: item[:ap_spend],
        caliber: attributes[:caliber1],
        action: attributes[:action_type],
        barrel_type: attributes[:barrel_type],
        barrel_length: attributes[:barrel_length],
        capacity: attributes[:capacity],
        finish: attributes[:finish_color],
        length: attributes[:size],
        frame: attributes[:frame_material],
        safety: attributes[:safety],
        sights: attributes[:sights],
        stock_frame_grips: attributes[:stockFrameGrips],
        magazine: attributes[:magazine],
        chamber: attributes[:chamber],
        casing: attributes[:finish_color],
        feet_per_second: attributes[:feet_per_second],
        grain: attributes[:grain_weight],
        hand: attributes[:left],
        model: attributes[:model1],
        units_per_box: attributes[:units_per_box],
      }
    end

  end
end
