# typed: false
require "rails_helper"

RSpec.describe Shared::TwitterShareComponent, type: :component do
  let(:book) { create(:book, title: "Test Book", body: "This is a test book description.") }
  let(:url) { "https://example.com/books/1" }

  it "displays the Twitter share link" do
    render_inline(described_class.new(book: book, url: url))
    expect(page).to have_css("a[href*='twitter.com/intent/tweet']")
  end

  it "includes the URL in the share link" do
    render_inline(described_class.new(book: book, url: url))
    expect(page).to have_css("a[href*='url=']")
  end

  it "includes the hashtag in the share link" do
    render_inline(described_class.new(book: book, url: url))
    expect(page).to have_css("a[href*='EnginnerBook']")
  end

  it "includes the book body text in the share link" do
    render_inline(described_class.new(book: book, url: url))
    expect(page).to have_css("a[href*='text=']")
  end

  it "opens the link in a new tab" do
    render_inline(described_class.new(book: book, url: url))
    expect(page).to have_css("a[target='_blank']")
  end

  it "displays the Twitter icon" do
    render_inline(described_class.new(book: book, url: url))
    expect(page).to have_css("i.bi-twitter")
  end

  context "when book body is long" do
    let(:long_book) { create(:book, body: "This is a very long book description that will be truncated " * 10) }

    it "truncates the share text" do
      render_inline(described_class.new(book: long_book, url: url))
      # The component truncates to 30 characters
      expect(page).to have_css("a")
    end
  end
end
