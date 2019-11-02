require 'rails_helper'

RSpec.describe "Classifieds API", type: :request do

  describe "GET /classifieds" do
    before { 
      FactoryBot.create_list :classified, 3
      get "/classifieds" 
    }

    it "works!" do
      expect(response).to be_success
    end

    it "returns all the entries" do
      expect(parsed_body.count).to eq Classified.all.count
    end
  end

  describe "GET /classifieds/:id" do
    let(:classified) { FactoryBot.create :classified } #= classified = FactoryBot.create :classified

    before { get "/classifieds/#{classified.id}" } #= get "/classifieds/#{classified.id}"

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
