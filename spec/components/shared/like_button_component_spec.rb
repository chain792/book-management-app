# typed: false
require "rails_helper"

RSpec.describe Shared::LikeButtonComponent, type: :component do
  let(:book) { create(:book) }
  let(:user) { create(:user) }

  context "when user has liked the book" do
    before do
      create(:like, user: user, book: book)
    end

    it "displays the unlike button" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_css('[data-testid="unlike-button"]')
    end

    it "displays a filled heart icon" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_css('svg.fill-current')
    end

    it "has the correct color for liked state" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_css('.text-rose-500')
    end
  end

  context "when user has not liked the book" do
    it "displays the like button" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_css('[data-testid="like-button"]')
    end

    it "displays an outline heart icon" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_css('svg[fill="none"]')
    end
  end

  context "when user is not logged in" do
    it "displays the like button" do
      render_inline(described_class.new(book: book, current_user: nil))
      expect(page).to have_css('[data-testid="like-button"]')
    end

    it "does not display the unlike button" do
      render_inline(described_class.new(book: book, current_user: nil))
      expect(page).not_to have_css('[data-testid="unlike-button"]')
    end
  end

  context "when book has likes" do
    before do
      create_list(:like, 3, book: book)
    end

    it "displays the like count" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_text("3")
    end
  end

  context "when book has no likes" do
    it "does not display the like count" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).not_to have_text("0")
    end
  end

  it "has the correct dom id" do
    render_inline(described_class.new(book: book, current_user: user))
    expect(page).to have_css("div[id*='like_button']")
  end
end
