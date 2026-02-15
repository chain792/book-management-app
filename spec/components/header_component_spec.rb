# typed: false
require "rails_helper"

RSpec.describe HeaderComponent, type: :component do
  context "when user is logged in" do
    let(:user) { create(:user, name: "Test User") }

    it "displays the user name" do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_text("Test User")
    end

    it "displays the dropdown menu" do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_css('[data-controller="dropdown"]')
    end

    it "displays the logout link" do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_text("ログアウト")
    end

    it "displays the profile link" do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_text("マイページ")
    end

    it "displays the new post button" do
      render_inline(described_class.new(current_user: user))
      expect(page).to have_text("新規投稿")
    end
  end

  context "when user is not logged in" do
    it "displays the login link" do
      render_inline(described_class.new(current_user: nil))
      expect(page).to have_text("ログイン")
    end

    it "displays the signup button" do
      render_inline(described_class.new(current_user: nil))
      expect(page).to have_text("サインアップ")
    end

    it "does not display the dropdown menu" do
      render_inline(described_class.new(current_user: nil))
      expect(page).not_to have_css('[data-controller="dropdown"]')
    end

    it "does not display the new post button" do
      render_inline(described_class.new(current_user: nil))
      expect(page).not_to have_text("新規投稿")
    end
  end

  it "displays the EngineerBook branding" do
    render_inline(described_class.new(current_user: nil))
    expect(page).to have_text("EngineerBook")
  end

  it "displays navigation links" do
    render_inline(described_class.new(current_user: nil))
    expect(page).to have_text("投稿一覧")
    expect(page).to have_text("カテゴリ")
  end
end
