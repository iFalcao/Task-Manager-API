require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  before { host! 'api.taskmanager.dev' }
  let!(:user) { create(:user) }  
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /tasks' do
    context 'when no param is sent' do
      before do
        create_list(:task, 5, user_id: user.id)
        get "/tasks", params: {}, headers: headers
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return 5 tasks' do
        expect(json_body[:data].count).to eq(5)
      end
    end

    context 'when filter and sorting params are sent' do
      let!(:notebook_task_1) { create(:task, title: 'Check notebook', user_id: user.id)}
      let!(:notebook_task_2) { create(:task, title: 'Buy notebook', user_id: user.id)}
      let!(:other_task_1) { create(:task, title: 'Fix the door', user_id: user.id)}
      let!(:other_task_2) { create(:task, title: 'Fix the car', user_id: user.id)}
      
      before do
        get "/tasks", params: { q: { title_cont: 'Notebook', s: 'title ASC' } }, headers: headers
      end

      it 'returns matching tasks' do
        returned_tasks_titles = json_body[:data].map { |task| task[:attributes][:title]}
        expect(returned_tasks_titles).to eq([notebook_task_2.title, notebook_task_1.title])
      end
    end
  end


  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before do
      get "/tasks/#{task.id}", params: {}, headers: headers
    end

    context 'when the task exists' do
      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return json data with the task' do
        expect(json_body[:data][:attributes][:title]).to eq(task.title)
      end
    end

    context 'when the task does not exist' do
      let(:task) { create(:task) }

      it 'return status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /tasks' do
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers
    end

    context 'when the task is valid' do
      let(:task_params) { attributes_for(:task) }

      it 'return status 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end

      it 'return json with the created task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end

      it 'assigns the created task to the current user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when the task is invalid' do
      let(:task_params) { attributes_for(:task, title: nil) }

      it 'return status 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not save the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).to be_nil
      end

      it 'return json with title error' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before do
      put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:task_params) do
        { title: 'New title'}
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the updated object' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end

      it 'update the task in the database' do
        expect( Task.find_by title: task_params[:title] ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:task_params) do
        { title: ''}
      end

      it 'return status 422' do
        expect(response).to have_http_status(422)
      end

      it 'return json with error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'update the task in the database' do
        expect( Task.find_by title: task_params[:title] ).to be_nil
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before do
      delete "/tasks/#{task.id}", params: {}, headers: headers
    end

    context 'when the task exist' do
      it 'return status 204' do
        expect(response).to have_http_status(204)
      end

      it 'delete the task' do
        expect(Task.find_by(id: task.id)).to be_nil
        expect { Task.find task.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
