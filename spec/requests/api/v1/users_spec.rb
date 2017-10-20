require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  # Fix API subdomain
  before { host! 'api.taskmanager.dev' }

  describe 'GET /users/:id' do
    before do 
      headers = { 'Accept' => 'application/vnd.taskmanager.v1' }
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'When the user exists' do
      it 'returns the user' do
        user_response = JSON.parse(response.body)
        expect(user_response['id']).to eq(user_id)
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'When the user does not exist' do
      # Overrid user id to simulate event of searching a invalid user
      let(:user_id) { 41232341 }
      
      it 'returns status 404' do
        expect(response).to have_http_status(404)        
      end
    end

  end
end