require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  let!(:me) { create(:user) }

  describe 'GET /show' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'ステータスコードが200で返る' do
        get profile_path
        expect(response).to have_http_status 200
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get profile_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end


  describe 'GET /edit' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'ステータスコードが200で返る' do
        get edit_profile_path
        expect(response).to have_http_status 200
        end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get edit_profile_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end

  describe 'PATCH /update' do
    let(:params) {
      { user: { name: 'request_test' } } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'upfateが成功する' do
        expect{ patch profile_path, params: params }.to change{ User.find(me.id).name }.to('request_test')
        expect(response).to have_http_status 302
        expect(response).to redirect_to profile_path
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ patch profile_path, params: params }.not_to change{ User.find(me.id).name }
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end
end
