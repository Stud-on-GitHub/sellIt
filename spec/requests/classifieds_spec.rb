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

  describe "POST /classifieds" do
    context "when unauthenticated" do
      it "returns unauthorized" do
        post "/classifieds"
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when authenticated" do
      let(:params) {
        { classified: { title: 'le titre', price: 34, description: 'la description de la petite annonce' } }
      }

      it "work!" do
        post "/classifieds", params: params, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it "creates a new classifield" do
        expect {
          post "/classifieds", params: params, headers: authentication_header
        }.to change { 
          current_user.classifieds.count 
        }.by 1
      end

      it "has correct fields values for the created classified" do
        post "/classifieds", params: params, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'le titre'
        expect(created_classified.price).to eq 34
        expect(created_classified.description).to eq 'la description de la petite annonce'
      end

      it "returns a bad request when a params is missing" do
        params[:classified].delete(:price)
        post "/classifieds", params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it "returns a bad request when a params is false" do
        params[:classified][:price] = "dfghjklkjhg"
        post "/classifieds", params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
