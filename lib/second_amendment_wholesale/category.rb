module SecondAmendmentWholesale
  class Category < Base

    include SecondAmendmentWholesale::API

    #Excludes brands and other non-categories returned from 2AW's Categories endpoint
    EXCLUDED_CATEGORY_IDS = [3, 26, 27]

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

      response = get_request('categories', headers)

      extract_categories(response.body[:children_data])
    end

    protected

    def extract_categories(response, categories = [])
      response.each do |category|
        unless EXCLUDED_CATEGORY_IDS.include?(category[:id])
          categories << map_hash(category) unless category[:name] == "Firearms"

          if category[:children_data].present?
            extract_categories(category[:children_data], categories)
          end
        end
      end

      categories
    end

    def map_hash(hash)
      {
        id: hash[:id],
        name: hash[:name],
        parent_id: hash[:parent_id],
      }
    end
  end
end
