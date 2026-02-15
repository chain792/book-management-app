# typed: false
require "rails_helper"

RSpec.describe BookCardComponent, type: :component do
  let(:category) { create(:category, name: "Ruby") }
  let(:user) { create(:user, name: "John Doe") }
  let(:book) { create(:book, title: "Test Book Title", body: "This is a test book body.", category: category, user: user) }

  it "displays the book title" do
    render_inline(described_class.new(book: book))
    expect(page).to have_text("Test Book Title")
  end

  it "displays the book body" do
    render_inline(described_class.new(book: book))
    expect(page).to have_text("This is a test book body.")
  end

  it "displays the category name" do
    render_inline(described_class.new(book: book))
    expect(page).to have_text("Ruby")
  end

  it "displays the user name" do
    render_inline(described_class.new(book: book))
    expect(page).to have_text("John Doe")
  end

  it "displays the comment count" do
    create(:comment, book: book)
    create(:comment, book: book)
    render_inline(described_class.new(book: book))
    expect(page).to have_text("2")
  end

  it "displays the like count" do
    create(:like, book: book)
    create(:like, book: book)
    render_inline(described_class.new(book: book))
    expect(page).to have_text("2")
  end

  it "has a link to the book detail page" do
    render_inline(described_class.new(book: book))
    expect(page).to have_css("a[href*='/books/']")
  end

  it "displays the details link text" do
    render_inline(described_class.new(book: book))
    expect(page).to have_text("詳細を見る")
  end
end
