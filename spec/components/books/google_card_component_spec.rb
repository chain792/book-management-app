# typed: false
require "rails_helper"

RSpec.describe Books::GoogleCardComponent, type: :component do
  let(:google_book) do
    {
      "volumeInfo" => {
        "title" => "Test Book",
        "authors" => ["John Doe", "Jane Smith"],
        "publishedDate" => "2023-01-15",
        "imageLinks" => {
          "thumbnail" => "https://example.com/thumbnail.jpg"
        }
      }
    }
  end

  it "displays the book title" do
    render_inline(described_class.new(google_book: google_book))
    expect(page).to have_text("Test Book")
  end

  it "displays the authors" do
    render_inline(described_class.new(google_book: google_book))
    expect(page).to have_text("John Doe, Jane Smith")
  end

  it "displays the published date" do
    render_inline(described_class.new(google_book: google_book))
    expect(page).to have_text("2023-01-15")
  end

  it "has a link to new book page with params" do
    render_inline(described_class.new(google_book: google_book))
    expect(page).to have_css("a[href*='/books/new']")
  end

  context "when book has no authors" do
    let(:google_book_no_authors) do
      {
        "volumeInfo" => {
          "title" => "Test Book",
          "authors" => []
        }
      }
    end

    it "displays 'Unknown Author'" do
      render_inline(described_class.new(google_book: google_book_no_authors))
      expect(page).to have_text("Unknown Author")
    end
  end

  context "when book has no title" do
    let(:google_book_no_title) do
      {
        "volumeInfo" => {}
      }
    end

    it "displays 'No Title'" do
      render_inline(described_class.new(google_book: google_book_no_title))
      expect(page).to have_text("No Title")
    end
  end
end
