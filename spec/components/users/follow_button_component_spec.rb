# typed: false
require "rails_helper"

RSpec.describe Users::FollowButtonComponent, type: :component do
  let(:user) { create(:user) }
  let(:current_user) { create(:user) }

  context "when current user is following the user" do
    before do
      current_user.follow(user)
    end

    it "displays the 'フォロー中' button" do
      render_inline(described_class.new(user: user, current_user: current_user))
      expect(page).to have_button("フォロー中")
    end

    it "has the unfollow styling" do
      render_inline(described_class.new(user: user, current_user: current_user))
      expect(page).to have_css('.bg-gray-200')
    end
  end

  context "when current user is not following the user" do
    it "displays the 'フォロー' button" do
      render_inline(described_class.new(user: user, current_user: current_user))
      expect(page).to have_button("フォロー")
    end

    it "has the follow styling" do
      render_inline(described_class.new(user: user, current_user: current_user))
      expect(page).to have_css('.bg-blue-600')
    end
  end

  context "when viewing own profile" do
    it "renders nothing" do
      result = render_inline(described_class.new(user: current_user, current_user: current_user))
      expect(result.to_html.strip).to be_empty
    end
  end

  context "when user is not logged in" do
    it "renders nothing" do
      result = render_inline(described_class.new(user: user, current_user: nil))
      expect(result.to_html.strip).to be_empty
    end
  end

  it "has the correct dom id" do
    render_inline(described_class.new(user: user, current_user: current_user))
    expect(page).to have_css("#follow-button-for-user-#{user.id}")
  end
end
