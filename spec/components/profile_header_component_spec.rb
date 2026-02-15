# typed: false
require "rails_helper"

RSpec.describe ProfileHeaderComponent, type: :component do
  let(:user) { create(:user, name: "Test User", email: "test@example.com", introduction: "Hello, I am a developer.") }

  it "displays the user name" do
    render_inline(described_class.new(user: user))
    expect(page).to have_text("Test User")
  end

  context "when user is a regular user" do
    it "displays the email address" do
      render_inline(described_class.new(user: user))
      expect(page).to have_text("test@example.com")
    end
  end

  context "when user is a guest user" do
    let(:guest_user) { create(:user, role: "guest", name: "Guest User") }

    it "does not display the email address" do
      render_inline(described_class.new(user: guest_user))
      expect(page).not_to have_css("svg + .normal-case", text: /@/)
    end
  end

  it "displays the user introduction" do
    render_inline(described_class.new(user: user))
    expect(page).to have_text("Hello, I am a developer.")
  end

  context "when user has no introduction" do
    let(:user_without_intro) { create(:user, introduction: nil) }

    it "does not display introduction section" do
      render_inline(described_class.new(user: user_without_intro))
      expect(page).not_to have_css(".max-w-xl")
    end
  end

  it "displays follower count" do
    follower = create(:user)
    follower.follow(user)
    render_inline(described_class.new(user: user))
    expect(page).to have_text("1")
    expect(page).to have_text("Followers")
  end

  it "displays following count" do
    following = create(:user)
    user.follow(following)
    render_inline(described_class.new(user: user))
    expect(page).to have_text("1")
    expect(page).to have_text("Following")
  end

  it "displays the edit button" do
    render_inline(described_class.new(user: user))
    expect(page).to have_text("編集する")
  end

  it "displays the member since date" do
    render_inline(described_class.new(user: user))
    expect(page).to have_text("Member since")
  end
end
