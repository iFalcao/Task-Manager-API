require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  before { host! 'api.taskmanager.dev' }
  let!(:user) { create(:user) }
  let!(:task) { create(:task) }
  
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get "/tasks", params: {}, headers: headers
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'return 5 tasks' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end


=begin
  describe 'GET /tasks/:id' do
    before do
      get "/tasks/#{task.id}", params: {}, headers: headers
    end

    context 'when the task exists' do
      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return json data with the task' do
        expect(json_body[:id]).to eq(task.id)
      end
    end

    context 'when the task does not exist' do
      
    end
  end
=end
end
