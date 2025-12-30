require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  describe 'コメントのCRUD' do
    let(:me) { create(:user) }
    let(:book) { create(:book) }
    let(:comment) { create(:comment) }
    let(:comment_by_me) { create(:comment, user: me) }
    before { login_as(me) }

    context '正常系' do
      it 'コメントを新規追加できる' do
        visit book_path(book)
        fill_in 'comment[body]', with: 'コメントテスト投稿'
        expect{
          click_button '投稿'
          expect(page).to have_content 'コメントテスト投稿'
        }.to change{ Comment.count }.by(1)
        expect(current_path).to eq book_path(book)
      end

      it 'コメントの編集ができる' do
        visit book_path(comment_by_me.book)
        find('#comments-list .dropdown').click
        click_link '編集する'
        find('#comments-list textarea').set('コメントテスト編集')
        click_button '保存'
        expect(page).to have_content 'コメントテスト編集' 
        expect(page).not_to have_content comment_by_me.body
        expect(current_path).to eq book_path(comment_by_me.book)
      end

      it 'コメントの編集をキャンセルできる' do
        visit book_path(comment_by_me.book)
        find('#comments-list .dropdown').click
        click_link '編集する'
        find('#comments-list textarea').set('コメントテスト編集')
        click_button 'キャンセル'
        expect(page).not_to have_content 'コメントテスト編集' 
        expect(page).to have_content comment_by_me.body 
        expect(current_path).to eq book_path(comment_by_me.book)
      end

      it 'コメントの削除できる' do
        visit book_path(comment_by_me.book)
        body = comment_by_me.body
        find('#comments-list .dropdown').click
        expect{
          click_link '削除'
          page.accept_confirm
          expect(page).not_to have_content comment_by_me.body
        }.to change{ Comment.count }.by(-1)
        expect(page).not_to have_content body
        expect(current_path).to eq book_path(comment_by_me.book)
      end

      it '自分が追加したコメントには歯車アイコンが表示される' do
        visit book_path(comment_by_me.book)
        expect(page).to have_selector '#comments-list .dropdown'
      end

      it '他人が追加したコメントには歯車アイコンが表示されない' do
        visit book_path(comment.book)
        expect(page).not_to have_selector '#comments-list .dropdown'
      end
    end

    context '異常系' do
      it '未入力な場合、コメントを新規追加できない' do
        visit book_path(book)
        fill_in 'comment[body]', with: ''
        expect{
          click_button '投稿'
          expect(page).to have_content 'コメントを入力してください'
        }.to change{ Comment.count }.by(0)
        expect(current_path).to eq book_path(book)
      end

      it '未入力な場合、コメントの編集ができない' do
        visit book_path(comment_by_me.book)
        find('#comments-list .dropdown').click
        click_link '編集する'
        find('#comments-list textarea').set('')
        click_button '保存'
        expect(page).to have_content 'コメントを入力してください'
        expect(current_path).to eq book_path(comment_by_me.book)
      end
    end
  end
end
