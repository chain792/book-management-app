module LoginMacros
  def login_as(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード',	with: 'password'
    click_button 'ログイン'

    expect(page).to have_current_path profile_path
  end
end
