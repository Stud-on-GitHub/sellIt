require 'rails_helper'

RSpec.describe "Classifieds API", type: :request do
  let(:classified) { FactoryBot.create :classified } #= classified = FactoryBot.create :classified

  before { get "/classifieds/#{classified.id}" } #=get "/classifieds/#{classified.id}"

  describe "GET /classifieds/:id" do
    it "works!" do
      #classified = FactoryBot.create :classified
      #get "/classifieds/#{classified.id}"
      expect(response).to be_success
    end

    it 'is correctly serialized' do
      #classified = FactoryBot.create :classified
      #get "/classifieds/#{classified.id}"
      #expect(JSON.parse(response.body)['id']).to eq classified.id
      #...
      expect(parsed_body['id']).to eq classified.id #with json_helper action/method
      expect(parsed_body['title']).to eq classified.title
      expect(parsed_body['price']).to eq classified.price
      expect(parsed_body['description']).to eq classified.description
    end
  end
end
