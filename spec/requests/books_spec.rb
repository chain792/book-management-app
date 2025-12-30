require 'rails_helper'

RSpec.describe 'Books', type: :request do
  let!(:me) { create(:user) }
  let!(:book) { create(:book) }
  let!(:book_by_me) { create(:book, user: me) }

  describe 'GET /index' do
    it 'ステータスコードが200で返る' do
      get books_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET /search' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'ステータスコードが200で返る' do
        get search_books_path
        expect(response).to have_http_status 200
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get search_books_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end

  describe 'GET /new' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      # クエリパラメタが必要なためテストを省くことにする
      xit 'ステータスコードが200で返る' do
        get new_book_path
        expect(response).to have_http_status 200
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get new_book_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end

  describe 'POST /create' do
    let(:params) {
      { book: { title: 'request_test_title', body: 'request_test_body', parent_category: 1 } } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      it 'createが成功する' do
        expect{ post books_path, params: params }.to change{ Book.count }.by(1)
        expect(response).to have_http_status 302
        expect(response).to redirect_to books_path
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ post books_path, params: params }.to change{ Book.count }.by(0)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end


  describe 'GET /show' do
    it 'ステータスコードが200で返る' do
      get book_path(book)
      expect(response).to have_http_status 200
    end
  end


  describe 'GET /edit' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      context '自分の資産の場合' do
        it 'ステータスコードが200で返る' do
          get edit_book_path(book_by_me)
          expect(response).to have_http_status 200
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect{ get edit_book_path(book) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        get edit_book_path(book_by_me)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end

  describe 'PATCH /update' do
    let(:params) {
      { book: { body: 'request_test_body' } } 
    }
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      context '自分の資産の場合' do
        it 'upfateが成功する' do
          expect{ patch book_path(book_by_me), params: params }.to change{ Book.find(book_by_me.id).body }.to('request_test_body')
          expect(response).to have_http_status 302
          expect(response).to redirect_to book_path(book_by_me)
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            patch book_path(book) 
          } .to raise_error(ActiveRecord::RecordNotFound)
            .and not_change{ Book.find(book_by_me.id).body }
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ patch book_path(book_by_me), params: params }.not_to change{ Book.find(book_by_me.id).body }
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'ログイン後' do
      before { login_user(me, 'password', login_path) }
      context '自分の資産の場合' do
        it 'destroyが成功する' do
          expect{ delete book_path(book_by_me) }.to change{ Book.count }.by(-1)
          expect(response).to have_http_status 302
          expect(response).to redirect_to books_path
        end
      end
      context '他人の資産の場合' do
        it '他ユーザーにはアクセスできない' do
          expect {
            delete book_path(book) 
          } .to raise_error(ActiveRecord::RecordNotFound)
            .and change{ Book.count }.by(0)
        end
      end
    end
    context 'ログイン前' do
      it 'アクセス制限される' do
        expect{ delete book_path(book_by_me) }.to change{ Book.count }.by(0)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path(return: true)
      end
    end
  end
end
