require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /index' do
    it 'リダイレクトされる' do
      get users_path
      expect(response).to have_http_status 302
      expect(response).to redirect_to new_user_path
    end
  end

  describe 'GET /new' do
    it 'ステータスコードが200で返る' do
      get new_user_path
      expect(response).to have_http_status 200
    end
  end

  describe 'POST /crete' do
    let(:params) {
      { user: { name: 'test', email: 'test@example.com', password: 'password', password_confirmation: 'password' } } 
    }

    it 'ユーザーが追加される' do
      expect{ post users_path, params: params }.to change{ User.count }.by(1)
      expect(response).to have_http_status 302
      expect(response).to redirect_to profile_path
    end
  end

  describe 'GET /show' do
    it 'ステータスコードが200で返る' do
      get user_path(user)
      expect(response).to have_http_status 200
    end
  end

  describe 'GET /following' do
    it 'ステータスコードが200で返る' do
      get following_user_path(user)
      expect(response).to have_http_status 200
    end
  end

  describe 'GET /follower' do
    it 'ステータスコードが200で返る' do
      get follower_user_path(user)
      expect(response).to have_http_status 200
    end
  end
end
