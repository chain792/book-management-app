require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:me) { create(:user) }
  let!(:book) { create(:book) }
  let!(:comment) { create(:comment) }
  let!(:comment_by_me) { create(:comment, user: me) }

  describe 'POST /create' do
    let(:params) {
      { comment: { body: 'request_test_body' } } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'createが成功する' do
        expect{ post book_comments_path(book), params: params, xhr: true }.to change{ Comment.count }.by(1)
        expect(response).to have_http_status 200
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ post book_comments_path(book), params: params, xhr: true }.to change{ Comment.count }.by(0)
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'PATCH /update' do
    let(:params) {
      { comment: { body: 'request_test_body' } } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      context '自分の資産の場合' do
        it 'upfateが成功する' do
          expect{ patch comment_path(comment_by_me), params: params, xhr: true }.to change{ Comment.find(comment_by_me.id).body }.to('request_test_body')
          expect(response).to have_http_status 200
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            patch comment_path(comment), xhr: true 
          } .to raise_error(ActiveRecord::RecordNotFound)
            .and not_change{ Comment.find(comment_by_me.id).body }
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ patch comment_path(comment_by_me), params: params , xhr: true}.not_to change{ Comment.find(comment_by_me.id).body }
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      context '自分の資産の場合' do
        it 'destroyが成功する' do
          expect{ delete comment_path(comment_by_me), xhr: true }.to change{ Comment.count }.by(-1)
          expect(response).to have_http_status 200
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            delete comment_path(comment), xhr: true 
          } .to raise_error(ActiveRecord::RecordNotFound)
            .and change{ Comment.count }.by(0)
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ delete comment_path(comment_by_me), xhr: true }.to change{ Comment.count }.by(0)
        expect(response).to have_http_status 200
      end
    end
  end
end
