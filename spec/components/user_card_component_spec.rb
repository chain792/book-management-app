# typed: false
require "rails_helper"

RSpec.describe UserCardComponent, type: :component do
  let(:user) { create(:user, name: "Test User", introduction: "I am a software engineer.") }
  let(:current_user) { create(:user) }

  it "displays the user name" do
    render_inline(described_class.new(user: user, current_user: current_user))
    expect(page).to have_text("Test User")
  end

  it "displays the user introduction" do
    render_inline(described_class.new(user: user, current_user: current_user))
    expect(page).to have_text("I am a software engineer.")
  end

  it "displays the user avatar" do
    render_inline(described_class.new(user: user, current_user: current_user))
    expect(page).to have_css("img")
  end

  it "has a link to the user profile" do
    render_inline(described_class.new(user: user, current_user: current_user))
    expect(page).to have_css("a[href*='/users/']")
  end

  context "when user has no introduction" do
    let(:user_without_intro) { create(:user, introduction: nil) }

    it "does not display the introduction section" do
      render_inline(described_class.new(user: user_without_intro, current_user: current_user))
      expect(page).not_to have_css(".border-t")
    end
  end

  context "when introduction is long" do
    let(:user_with_long_intro) { create(:user, introduction: "This is a very long introduction " * 10) }

    it "truncates the introduction" do
      render_inline(described_class.new(user: user_with_long_intro, current_user: current_user))
      # The component truncates to 80 characters
      expect(page).to have_css(".text-sm")
    end
  end

  it "includes the follow button component" do
    render_inline(described_class.new(user: user, current_user: current_user))
    # The FollowButtonComponent is rendered inside
    expect(page).to have_button("フォロー")
  end

  context "when viewing own card" do
    it "does not display follow button" do
      render_inline(described_class.new(user: current_user, current_user: current_user))
      expect(page).not_to have_button("フォロー")
      expect(page).not_to have_button("フォロー中")
    end
  end
end
