module LoginMacros
  def login_as(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password',	with: 'password'
    click_button 'ログイン'

    expect(page).to have_current_path profile_path
  end
end
