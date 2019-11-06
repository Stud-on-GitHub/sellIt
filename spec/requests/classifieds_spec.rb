require 'rails_helper'
require 'pp'

RSpec.describe "Classifieds API", type: :request do
  let(:classified) { FactoryBot.create :classified, user_id: current_user.id }

  describe "GET /classifieds" do
    let(:page) { 3 }
    let(:per_page) { 5 }

    context "when everything goes well" do
      # before { 
      #   FactoryBot.create_list :classified, 18
      # }
      before { 
        FactoryBot.create_list :classified, 5, category: "car" # add filter, it's a optional parameter
        FactoryBot.create_list :classified, 12, category: "motocycle"
      }

      it "works!" do
        # get "/classifieds"
        # expect(response).to be_success # code 200
        get "/classifieds", params: { page: page, per_page: per_page, order: "asc" } # add pagination and order     
        expect(response).to have_http_status :partial_content # code 206
      end

      # it "returns all the entries" do
      #   expect(parsed_body.count).to eq Classified.all.count
      # end
      # it "returns paginate results" do
      #   expect(parsed_body.map { |r| r['id'] }).to eq Classified.all.limit(per_page).offset((page - 1) * per_page).pluck(:id) #= or [11, 12, 13, 14, 15]
      # end
      it "returns paginate results  when order is asc" do
        get "/classifieds", params: { page: page, per_page: per_page, order: "asc" }
        expect(parsed_body.map { |r| r['id'] }).to eq Classified.all.order(created_at: "asc").limit(per_page).offset((page - 1) * per_page).pluck(:id) #= or [11, 12, 13, 14, 15]
      end

      it "returns paginate results  when order is desc" do
        get "/classifieds", params: { page: page, per_page: per_page, order: "desc" }
        expect(parsed_body.map { |r| r['id'] }).to eq Classified.all.order(created_at: "desc").limit(per_page).offset((page - 1) * per_page).pluck(:id) #= or [11, 12, 13, 14, 15]
      end

      it "returns categorized results when category optional parameter is given" do
        get "/classifieds", params: { page: page, per_page: per_page, order: "asc", category: "car" }
        parsed_body.each { |classified| expect(classified["category"]).to eq "car" }
      end

      it "returns the correct results when searching" do
        classified1 = FactoryBot.create :classified, title: "The birds awesome do it"
        classified2 = FactoryBot.create :classified, title: "Too much information"
        classified3 = FactoryBot.create :classified, title: "My awesome title"
        get "/classifieds", params: { page: 1, per_page: 5, order: "asc", query: "awesome" }
        expect(parsed_body.map { |r| r['id'] }).to eq [classified1.id, classified3.id]
      end
    end

    # it "returns a bad request when parameters are missing" do
    #   get "/classifieds"
    #   expect(response).to have_http_status :bad_request
    #   expect(parsed_body.keys).to include 'error'
    #   expect(parsed_body['error']).to eq 'missing parameters'
    # end

    it "returns a bad request when page parameter is missing" do
      get "/classifieds", params: {per_page: per_page, order: "asc"}
      expect(response).to have_http_status :bad_request
      expect(parsed_body.keys).to include 'error'
      expect(parsed_body['error']).to eq 'missing parameter page'
    end

    it "returns a bad request when per page parameter is missing" do
      get "/classifieds", params: {page: page, order: "asc"}
      expect(response).to have_http_status :bad_request
      expect(parsed_body.keys).to include 'error'
      expect(parsed_body['error']).to eq 'missing parameter per_page'
    end

    it "returns a bad request when order parameter is missing" do
      get "/classifieds", params: {page: page, per_page: per_page}
      expect(response).to have_http_status :bad_request
      expect(parsed_body.keys).to include 'error'
      expect(parsed_body['error']).to eq 'missing parameter order'
    end

    it "returns a bad request when order parameter is false" do
      get "/classifieds", params: {page: page, per_page: per_page, order: "ysiydi"}
      expect(response).to have_http_status :bad_request
      expect(parsed_body.keys).to include 'error'
      expect(parsed_body['error']).to eq 'order parameter must be asc or desc'
    end
  end

  describe "GET /classifieds/:id" do
    # let(:classified) { FactoryBot.create :classified } #= classified = FactoryBot.create :classified

    context "when everything goes well" do
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
        # pp parsed_body 
        # expect(parsed_body['id']).to eq classified.id #with json_helper action/method
        # expect(parsed_body['title']).to eq classified.title
        # expect(parsed_body['price']).to eq classified.price
        # expect(parsed_body['description']).to eq classified.description
        # or
        expect(parsed_body).to match({
          id: classified.id,
          title: classified.title,
          price: classified.price,
          description: classified.description,
          category: classified.category, # add category
          user: {
            id: classified.user.id,
            fullname: classified.user.fullname
          }.stringify_keys # symbol to string
        }.stringify_keys)
      end
    end
    
    it "returns a not found when the resource can't be found" do
      get "/classifieds/toto"
      expect(response).to have_http_status :not_found
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

  describe "PATCH /classifieds/:id" do
    # let(:classified) { FactoryBot.create :classified, user_id: current_user.id }

    let(:params) {
      { classified: { title: 'un autre titre', price: 56 } }
    }

    context "when unauthenticated" do
      it "returns unauthorized" do
        patch "/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when authenticated" do
      context "when everything goes well" do
        before { patch "/classifieds/#{classified.id}", params: params, headers: authentication_header }

        it { expect(response).to be_success }

        it "modifies the given fields of the resource" do
          updated_classified = Classified.find(classified.id)
          expect(updated_classified.title).to eq 'un autre titre'
          expect(updated_classified.price).to eq 56
        end
      end

      it "returns a bad request when params is false" do
        params[:classified][:price] = "dfghjklkjhg"
        patch "/classifieds/#{classified.id}", params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it "returns a not found when resource can be found" do
        patch "/classifieds/toto", params: params, headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it "returns a forbidden when the requester is not the owner of the resource" do
        another_classified = FactoryBot.create :classified
        patch "/classifieds/#{another_classified.id}", params: params, headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe "DELETE /classifieds/:id" do 
    context "when unauthenticated" do
      it "returns unauthorized" do
        delete "/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when authenticated" do
      context "when everything goes well" do
        before { delete "/classifieds/#{classified.id}", headers: authentication_header }

        it { expect(response).to have_http_status :no_content }

        it "deletes the given classified" do
          expect(Classified.find_by(id: classified.id)).to eq nil # find_by() if not found => no error, with find() => error
        end
      end

      it "returns a not found when resource can be found" do
        delete "/classifieds/toto", headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it "returns a forbidden when the requester is not the owner of the resource" do
        another_classified = FactoryBot.create :classified
        delete "/classifieds/#{another_classified.id}", headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
