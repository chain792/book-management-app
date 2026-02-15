module LoginMacros
  def login_as(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード',	with: 'password'
    click_button 'ログインする'

    expect(page).to have_current_path profile_path
  end

  def login_user(user, password = 'password')
    post session_path, params: { email: user.email, password: password }
  end
end
