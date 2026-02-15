require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    context '正常系' do
      it 'ログインができる' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード',	with: 'password'
        click_button 'ログインする'
        expect(page).to have_current_path profile_path
        expect(page).to have_content 'ログインしました'
      end
    end

    context '異常系' do
      it '入力が不足している場合、ログインできない' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        click_button 'ログインする'
        expect(page).to have_current_path login_path
        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end

  describe 'ログアウト' do
    context '正常系' do
      it 'ログアウトができる' do
        login_as(user)
        find('header [data-controller="dropdown"] button', match: :first).click
        click_link 'ログアウト'
        expect(page).to have_current_path root_path
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end
