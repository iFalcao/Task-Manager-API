require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  before { host! 'api.taskmanager.dev' }
  let!(:user) { create(:user) }  
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


  describe 'GET /tasks/:id' do
    let(:task) { create(:task) }
    let(:task_id) { task.id }
    before do
      get "/tasks/#{task_id}", params: {}, headers: headers
    end

    context 'when the task exists' do
      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return json data with the task' do
        expect(json_body[:title]).to eq(task.title)
      end
    end

    context 'when the task does not exist' do
      let(:task_id) { 435453453 }

      it 'return status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

end
