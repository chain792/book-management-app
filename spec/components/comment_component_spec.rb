# typed: false
require "rails_helper"

RSpec.describe CommentComponent, type: :component do
  let(:book) { create(:book) }
  let(:user) { create(:user, name: "Commenter") }
  let(:comment) { create(:comment, body: "This is a great book!", user: user, book: book) }

  it "displays the comment body" do
    render_inline(described_class.new(comment: comment, current_user: nil))
    expect(page).to have_text("This is a great book!")
  end

  it "displays the commenter name" do
    render_inline(described_class.new(comment: comment, current_user: nil))
    expect(page).to have_text("Commenter")
  end

  it "displays the commenter avatar" do
    render_inline(described_class.new(comment: comment, current_user: nil))
    expect(page).to have_css("img")
  end

  context "when the comment belongs to the current user" do
    it "displays the dropdown menu" do
      render_inline(described_class.new(comment: comment, current_user: user))
      expect(page).to have_css('[data-controller="dropdown"]')
    end

    it "displays the edit button" do
      render_inline(described_class.new(comment: comment, current_user: user))
      expect(page).to have_text("編集する")
    end

    it "displays the delete button" do
      render_inline(described_class.new(comment: comment, current_user: user))
      expect(page).to have_text("削除する")
    end
  end

  context "when the comment belongs to another user" do
    let(:other_user) { create(:user) }

    it "does not display the dropdown menu" do
      render_inline(described_class.new(comment: comment, current_user: other_user))
      expect(page).not_to have_css('[data-controller="dropdown"]')
    end

    it "does not display the edit button" do
      render_inline(described_class.new(comment: comment, current_user: other_user))
      expect(page).not_to have_text("編集する")
    end

    it "does not display the delete button" do
      render_inline(described_class.new(comment: comment, current_user: other_user))
      expect(page).not_to have_text("削除する")
    end
  end

  context "when user is not logged in" do
    it "does not display the dropdown menu" do
      render_inline(described_class.new(comment: comment, current_user: nil))
      expect(page).not_to have_css('[data-controller="dropdown"]')
    end
  end
end
