require "spec_helper"

describe SecondAmendmentWholesale::Catalog do

  let(:options) { { token: '123456' } }

  before do
    stub_request(:get, "https://staging.2ndamendmentwholesale.com/rest/V1/feed/productV2").
      with(headers: {'Authorization'=> 'Bearer 123456'}).
      to_return(:status => 200, :body => FixtureHelper.get_fixture_file('Catalog.json').read, :headers => {})

    stub_request(:get, "https://staging.2ndamendmentwholesale.com/rest/V1/feed/attributes").
      with(headers: {'Authorization'=> 'Bearer 123456'}).
      to_return(:status => 200, :body => FixtureHelper.get_fixture_file('Attributes.json').read, :headers => {})

    stub_request(:get, "https://staging.2ndamendmentwholesale.com/rest/V1/categories").
      with(headers: {'Authorization'=> 'Bearer 123456'}).
      to_return(:status => 200, :body => FixtureHelper.get_fixture_file('Categories.json').read, :headers => {})
  end

  describe '.all' do
    it 'returns an array of all items' do
      items = SecondAmendmentWholesale::Catalog.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:upc]).to eq('702038266228')
          expect(item[:name]).to eq('Juggernaut Tactical Silent Stock System - Black | AR10 | Featureless')
        when 1
          expect(item[:upc]).to eq('856534007387')
          expect(item[:brand]).to eq('Gear Head Works')
        end
      end

      expect(items.count).to eq(2)
    end
  end

end
