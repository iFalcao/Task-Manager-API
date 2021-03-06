require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  # Fix API subdomain
  before { host! 'api.taskmanager.dev' }

  describe 'GET /users/:id' do
    before do 
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'When the user exists' do
      it 'returns the user' do
        expect(json_body[:id]).to eq(user_id)
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
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'When the params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns correct json for the created user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'When the params are invalid' do
      let(:user_params) { attributes_for(:user, email:'invalid_email.com' ) }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json with errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'When the params are valid' do
      let(:user_params) { { email: 'new_test@gmail.com' } }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns correct json for the updated user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'When the params are invalid' do
      let(:user_params) { attributes_for(:user, email:'invalid_email@' ) }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json with errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    context 'When the user exists' do
      it 'Deleted the user' do
        expect( User.find_by(id: user_id) ).to(be_nil)
        expect { User.find user_id }.to raise_error(ActiveRecord::RecordNotFound)
      end
      
      it 'Returns status 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

end