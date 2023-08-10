require "spec_helper"

describe SecondAmendmentWholesale::Inventory do

  let(:options) { { token: '123456' } }

  before do
    stub_request(:get, "https://www.2ndamendmentwholesale.com/rest/V1/feed/stockV2").
      with(headers: {'Authorization'=> 'Bearer 123456'}).
      to_return(:status => 200, :body => FixtureHelper.get_fixture_file('inventory.json').read, :headers => {})
  end

  describe '.all' do
    it 'returns an array of all items' do
      items = SecondAmendmentWholesale::Inventory.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:item_identifier]).to eq('MA-17200-BST')
          expect(item[:quantity]).to eq(0)
        when 2
          expect(item[:item_identifier]).to eq('TH1-BLK')
          expect(item[:price]).to eq(79.99)
        end
      end

      expect(items.count).to eq(4)
    end
  end

end