require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:me) { create(:user) }
  let!(:book) { create(:book) }
  let!(:like) { create(:like) }
  let!(:like_by_me) { create(:like, user: me) }

  describe 'POST /create' do
    let(:params) {
      { book_id: book.id } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password') }
      it 'createが成功する' do
        expect{ post likes_path, params: params, xhr: true }.to change{ Like.count }.by(1)
        expect(response).to have_http_status :see_other
        expect(response).to redirect_to book_path(book)
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ post likes_path, params: params, xhr: true }.to change{ Like.count }.by(0)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'ログイン後' do
      before { login_user(me, 'password') }
      context '自分の資産の場合' do
        it 'destroyが成功する' do
          expect{ delete like_path(like_by_me), xhr: true }.to change{ Like.count }.by(-1)
          expect(response).to have_http_status :see_other
          expect(response).to redirect_to book_path(like_by_me.book)
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          delete like_path(like), xhr: true 
          expect(response).to have_http_status 404
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ delete like_path(like_by_me), xhr: true }.to change{ Like.count }.by(0)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
