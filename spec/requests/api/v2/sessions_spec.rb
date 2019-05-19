require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end
  # Fix API subdomain
  before { host! 'api.taskmanager.dev' }

  describe 'POST /auth/sign_in' do
    before do
      post '/auth/sign_in', params: credentials.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the authentication data in the headers' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')

        user.reload
        expect(json_body[:data][:auth_token]).to eq(user.auth_token)
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid_password' } }

      it 'returns status 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns json with errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth/sign_out' do
    let(:auth_token) { user.auth_token }

    before do
      delete "/auth/sign_out", params: {}, headers: headers
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    it 'changes the user authentication token' do
      user.reload
      expect(user).not_to be_valid_token(auth_data['access-token'], 
                                         auth_data['client'])
    end
  end
end