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

  describe 'POST /users' do
    before do
      headers = { 'Accept' => 'application/vnd.taskmanager.v1' }
      post '/users', params: { user: user_params }, headers: headers
    end

    context 'When the params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns correct json for the created user' do
        user_response = JSON.parse(response.body)
        expect(user_response['email']).to eq(user_params[:email])
      end
    end

    context 'When the params are ivvalid' do
      let(:user_params) { attributes_for(:user, email:'invalid_email.com' ) }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json with errors' do
        user_response = JSON.parse(response.body)
        expect(user_response).to have_key('errors')
      end
    end
  end
end