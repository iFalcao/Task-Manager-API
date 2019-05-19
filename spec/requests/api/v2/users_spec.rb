require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  # Fix API subdomain
  before { host! 'api.taskmanager.dev' }

  describe 'GET /auth/validate_token' do
    before do 
      get "/auth/validate_token", params: {}, headers: headers
    end

    context 'When the request headers are valid' do
      before do 
        get "/auth/validate_token", params: {}, headers: headers
      end

      it 'returns the user id' do
        expect(json_body[:data][:id].to_i).to eq(user.id)
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'When the request headers are invalid' do
      before do 
        headers['access-token'] = 'invalid token'
        get '/auth/validate_token', params: {}, headers: headers
      end
      
      it 'returns status 401' do
        expect(response).to have_http_status(401) 
      end
    end

  end

  describe 'POST /auth' do
    before do
      post '/auth', params: user_params.to_json, headers: headers
    end

    context 'When the params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns correct json for the created user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
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

  describe 'PUT /auth' do
    before do
      put "/auth", params: user_params.to_json, headers: headers
    end

    context 'When the params are valid' do
      let(:user_params) { { email: 'new_test@gmail.com' } }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns correct json for the updated user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
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

  describe 'DELETE /auth' do
    before do
      delete "/auth", params: {}, headers: headers
    end

    context 'When the user exists' do
      it 'Deleted the user' do
        expect( User.find_by(id: user.id) ).to(be_nil)
        expect { User.find user.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
      
      it 'Returns status 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

end