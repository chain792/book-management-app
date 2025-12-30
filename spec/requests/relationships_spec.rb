require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:me) { create(:user) }
  let!(:others) { create(:user) }
  let!(:relationship) { create(:relationship) }
  let!(:relationship_I_followed) { create(:relationship, followed: me) }

  describe 'POST /create' do
    let(:params) {
      { follower_id: others.id } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'createが成功する' do
        expect{ post relationships_path, params: params, xhr: true }.to change{ Relationship.count }.by(1)
        expect(response).to have_http_status 200
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ post relationships_path, params: params, xhr: true }.to change{ Relationship.count }.by(0)
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      context '自分の資産の場合' do
        it 'destroyが成功する' do
          expect{ delete relationship_path(relationship_I_followed), xhr: true }.to change{ Relationship.count }.by(-1)
          expect(response).to have_http_status 200
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            delete like_path(relationship), xhr: true 
            } .to raise_error(ActiveRecord::RecordNotFound)
            .and change{ Relationship.count }.by(0)
          end
        end
      end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ delete relationship_path(relationship_I_followed), xhr: true }.to change{ Relationship.count }.by(0)
        expect(response).to have_http_status 200
      end
    end
  end
end
