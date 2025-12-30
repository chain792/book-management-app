require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:me) { create(:user) }
  describe 'GET /index' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'ステータスコードが200で返る' do
        get categories_path
        expect(response).to have_http_status 200
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get categories_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end

  describe 'GET /show' do
    it 'ステータスコードが200で返る' do
      get category_path(id: 1)
      expect(response).to have_http_status 200
    end
  end
end
