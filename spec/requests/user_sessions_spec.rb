require 'rails_helper'

RSpec.describe 'UserSessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET /new' do
    it 'ステータスコードが200で返る' do
      get login_path
      expect(response).to have_http_status 200
    end
  end

  describe 'POST /crete' do
    let(:params) {
      { email: user.email, password: 'password' }
    }

    it 'ログインに成功すること' do
      post login_path, params: params
      expect(response).to have_http_status 302
      expect(response).to redirect_to profile_path
    end
  end

  describe 'DELETE /destroy' do
    before { login_user(user, 'password', login_path) }
    it 'ログアウトに成功すること' do
      delete logout_path
      expect(response).to have_http_status 302
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST /guest_login' do
    it 'ログインに成功すること' do
      post guest_login_path
      expect(response).to have_http_status 302
      expect(response).to redirect_to profile_path
    end
  end
end
