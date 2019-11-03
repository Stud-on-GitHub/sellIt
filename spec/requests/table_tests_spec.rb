require 'rails_helper'

RSpec.describe "Table Tests API", type: :request do
  describe '#ping' do

    context 'when unauthorized' do
      before { get '/ping' }

      it 'works' do
        expect(response).to be_success
      end
      it 'return unauthorized' do
        expect(parsed_body['response']).to eq 'unauthorized'
      end
    end

    context 'when authorized' do
      # let(:current_user) { FactoryBot.create :user }
      # let(:auth_headers) {
      #   token = Knock::AuthToken.new(payload: { sub: current_user.id }).token
      #   {
      #     "Authorization": "Bearer #{token}"
      #   }
      # }
      # before { get '/ping', headers: auth_headers }

      before { get '/ping', headers: authentication_header }

      it 'works' do
        expect(response).to be_success
      end

      it 'return authorized pong' do
        expect(parsed_body['response']).to eq 'authorized pong'
      end
    end
  end
end