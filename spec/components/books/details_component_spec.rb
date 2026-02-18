# typed: false
require "rails_helper"

RSpec.describe Books::DetailsComponent, type: :component do
  let(:category) { create(:category, name: "Programming") }
  let(:user) { create(:user, name: "Author Name") }
  let(:book) { create(:book, title: "Clean Code", body: "A great book about programming.", category: category, user: user, published_date: "2023-01-01") }
  let(:author) { create(:author, name: "Robert Martin") }

  before do
    book.authors << author
  end

  it "displays the book title" do
    render_inline(described_class.new(book: book, current_user: nil))
    expect(page).to have_text("Clean Code")
  end

  it "displays the author list" do
    render_inline(described_class.new(book: book, current_user: nil))
    expect(page).to have_text("Robert Martin (著)")
  end

  it "displays the category breadcrumb" do
    render_inline(described_class.new(book: book, current_user: nil))
    expect(page).to have_text("Programming")
  end

  it "displays the published date" do
    render_inline(described_class.new(book: book, current_user: nil))
    expect(page).to have_text("2023-01-01")
  end

  it "displays the book body" do
    render_inline(described_class.new(book: book, current_user: nil))
    expect(page).to have_text("A great book about programming.")
  end

  context "when the book belongs to the current user" do
    it "displays the edit/delete menu" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_css('[data-testid="book-actions"]')
    end

    it "displays the edit link" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_text("編集する")
    end

    it "displays the delete link" do
      render_inline(described_class.new(book: book, current_user: user))
      expect(page).to have_text("削除する")
    end
  end

  context "when the book belongs to another user" do
    let(:other_user) { create(:user, name: "Other User") }

    it "does not display the edit/delete menu" do
      render_inline(described_class.new(book: book, current_user: other_user))
      expect(page).not_to have_css('[data-testid="book-actions"]')
    end
  end

  context "when user is not logged in" do
    it "does not display the edit/delete menu" do
      render_inline(described_class.new(book: book, current_user: nil))
      expect(page).not_to have_css('[data-testid="book-actions"]')
    end
  end

  it "displays the Google Books link" do
    render_inline(described_class.new(book: book, current_user: nil))
    expect(page).to have_text("詳細を見る（Google Books）")
  end
end
