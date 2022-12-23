require 'rails_helper'

describe Api::V1::ProjectsController, type: :request do
  let(:user) { FactoryBot.create :user, post: post }
  let(:post) { 'support' }
  before do
    allow(JsonWebToken).to receive(:decode).and_return({ 'user_id' => user.id, 'expires_at' => Time.zone.now + 1.day })
  end

  describe "GET#index" do
    let(:api_path) { '/api/v1/projects' }

    context 'when user has permissions' do
      let(:post) { 'project owner' }
      let(:another_project_owner) { FactoryBot.create :user  }
      let!(:project1) { FactoryBot.create(:project, owner_id: user.id) }
      let!(:project2) { FactoryBot.create(:project, owner_id: another_project_owner.id, estimated_end_date: '01-01-2024') }

      before do
        get api_path, headers: { 'Authorization': 'api_token' }, params: params 
      end

      context 'without filtration' do
        let(:params) { {} }
        let(:all_projects) { 
          [
            {
              'id' => project1.id,
              'name' => project1.name,
              'start_date' => project1.start_date,
              'estimated_end_date' => project1.estimated_end_date.iso8601(3),
              'end_date' => project1.end_date,
              'status' => project1.status,
              'owner_id' => user.id,
              'manager_id' => project1.manager_id,
              'price' => project1.price
            },
            {
              'id' => project2.id,
              'name' => project2.name,
              'start_date' => project2.start_date,
              'estimated_end_date' => project2.estimated_end_date.iso8601(3),
              'end_date' => project2.end_date,
              'status' => project2.status,
              'owner_id' => another_project_owner.id,
              'manager_id' => project2.manager_id,
              'price' => project2.price
            }
          ]
        }

        it 'returns success response' do
          expect(response).to be_successful
        end

        it 'returns all projects' do
          expect(response.parsed_body).to eq all_projects
        end
      end

      context 'with filters' do
        let(:params) { { estimated_end_date_before: '06-01-2023' } }
        let(:filtered_project) { 
          [
            {
              'id' => project1.id,
              'name' => project1.name,
              'start_date' => project1.start_date,
              'estimated_end_date' => project1.estimated_end_date.iso8601(3),
              'end_date' => project1.end_date,
              'status' => project1.status,
              'owner_id' => user.id,
              'manager_id' => project1.manager_id,
              'price' => project1.price
            }
          ]
        }

        it 'returns success response' do
          expect(response).to be_successful
        end

        it 'returns only filtered project' do
          expect(response.parsed_body).to eq filtered_project
        end
      end
    end

    context 'when user does not have permissions' do
      let(:post) { 'employee' }
      let(:access_error) { { 'message' => 'You are not authorized to access this page.' } }

      before do
        get api_path, headers: { 'Authorization': 'api_token' }
      end

      it 'returns 403 status' do
        expect(response.status).to eq 403
      end

      it 'returns error' do
        expect(response.parsed_body).to eq access_error
      end
    end
  end

  describe 'failed test' do
    it 'fails' do
      expect(2).to eq 1  
    end
  end
end
